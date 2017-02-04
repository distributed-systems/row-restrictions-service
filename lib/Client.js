(function() {
    'use strict';


    const Cachd = require('cachd');
    const distributed = require('distributed-prototype');




    module.exports = class RowRestrictionClient {


        constructor(options) {
            this.gateway = options.gateway;
            this.serviceName = options.serviceName;

            
            // cache by principal
            this.cache = new Cachd({
                  ttl: 3600000
                , maxLength: 10000
                , removalStrategy: 'leastUsed'  
            });
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
                    if (response.status === 'ok') return Promise.resolve(response.data);
                    else return Promise.reject(response.toError());
                });


                this.cache.set(principalId, promise);

                return promise;
            }
        }
    }
})();
