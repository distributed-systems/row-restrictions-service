(function() {
    'use strict';


    const Cachd                 = require('cachd');
    const log                   = require('ee-log');
    const distributed           = require('distributed-prototype');
    const RequestMiddleware     = distributed.RequestMiddleware;



    const debug = process.argv.includes('--debug-row-restrictions');




    module.exports = class RowRestrictionClient extends RequestMiddleware {


        constructor(options) {
            super();


            this.gateway = options.gateway;
            this.serviceName = options.serviceName;

            if (!this.serviceName) throw new Error(`The row restirctions middleware requires a servicename to work properly!`);
            
            // cache by principal
            this.cache = new Cachd({
                  ttl: 3600000
                , maxLength: 10000
                , removalStrategy: 'leastUsed'  
            });
        }







        hookIncomingRequests() {
            return true;
        }







        /**
        * get the row restrictions for the current request
        */
        processIncomingRequest(request, response) {


            if (request.hasTrustedModule('permissions')) {
                const roles = Array.from(request.getTrustedModule('permissions').getRoleIds());


                return this.getRestrictions(roles).then((restrictions) => {

                    // store on request
                    request.setTrustedModule('row-restrictions', restrictions);


                    // continue
                    return Promise.resolve();
                }).catch((err) => {
                    response.error('row_restrictions_error', `Failed to load row-restrictions for the ${request.service}/${request.resource} resource!`, err)
                
                    // this was the last middleware that has to be called
                    // the response is sent
                    return Promise.resolve(true);
                });
            } else {
                response.error('row_restrictions_error', `Cannot get the row-restrictions for the ${request.service}/${request.resource} resource: the permissions trusted module is not available!`)
                
                // this was the last middleware that has to be called
                // the response is sent
                return Promise.resolve(true);
            }
        }







        getRestrictions(principalIds) { 
            return Promise.all(principalIds.map((id) => {
                return this.loadRestriction(id);
            })).then((arrays) => {

                // get unique values
                const map = new Map();
                Array.prototype.concat.apply([], arrays).forEach(item => map.set(item.id, item));
                return Promise.resolve(Array.from(map.values()));
            });
        }







        loadRestriction(principalId) {
            if (this.cache.has(principalId)) return this.cache.get(principalId);
            else {
                const filter = new distributed.FilterBuilder().and();

                // filter by service
                filter.entity('service').property('identifier').comparator('=').value(this.serviceName);

                // filter by pricipal
                filter.entity('principal').property('id').comparator('=').value(principalId)
                filter.entity('principalType').property('identifier').comparator('=').value('role');


                const promise = new distributed.RelationalRequest({
                      action: 'list'
                    , service: 'row-restrictions'
                    , resource: 'restriction'
                    , filter: filter
                }).send(this.gateway).then((response) => {
                    if (response.status === 'ok') {

                        if (debug) {
                            log.highlight(`loaded row restrictions for the principal ${principalId}:`);
                            log(response.data);
                        }

                        return Promise.resolve(response.data);
                    } else {

                        if (debug) {
                            log.warn(`Failed to load row restrictions for the principal ${principalId}:`);
                            log(response.toError());
                        }

                        return Promise.reject(response.toError());
                    }
                });

                // dont use the cache when debugging
                if (!debug) this.cache.set(principalId, promise);

                return promise;
            }
        }
    }
})();
