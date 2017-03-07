(function() {
    'use strict';

    const distributed                   = require('distributed-prototype');
    const RelationalResourceController  = distributed.RelationalResourceController;
    const log                           = require('ee-log');






    module.exports = class Restriction extends RelationalResourceController {


        constructor(options) {
            super('restriction');

            // db from the service
            this.db = options.db;
            this.Related = options.Related;

            // permissions listings
            this.enableAction('createOne');
            this.enableAction('create');
            this.enableAction('list');
        }









        /**
         * returns the items for a service
         */
        list(request, response) {
            const serviceName = this.getFilterValue(request.filter, 'service', 'identifier', '=');
            const principalId = this.getFilterValue(request.filter, 'principal', 'id', '=');
            const principalType = this.getFilterValue(request.filter, 'principalType', 'identifier', '=');
            

            const query = this.db.rowRestriction('*');

            // filter by service?
            if (serviceName) query.getService({identifier: serviceName});

            query.getAction('identifier');
            query.getResource('identifier');
            query.getValueType('identifier');
            query.getComparator('identifier');
            query.getService('identifier');


            if (principalId) {
                const principalQuery = query.getPrincipal('*', {
                    principalId: principalId
                });

                if (principalType) {
                    principalQuery.getPrincipalType('identifier', {
                        identifier: principalType
                    });
                } else principalQuery.getPrincipalType('identifier');
            } else query.getPrincipal('*').getPrincipalType('identifier');
            

            query.find().then((restrictions) => {
                
 
                // reformat
                response.ok(restrictions.map((restriction) => ({
                    principals: restriction.principal.map(p => ({
                          id: p.principalId
                        , type: p.principalType.identifier
                    }))
                    , actions: restriction.action.map(a => a.identifier)
                    , resources: restriction.resource.map(r => r.identifier)
                    , valueType: restriction.valueType.identifier
                    , comparator: restriction.comparator.identifier
                    , service: restriction.service.identifier
                    , property: restriction.property
                    , value: restriction.value.value
                    , nullable: restriction.nullable
                    , global: restriction.global
                    , id: restriction.id
                })));
            }).catch(err => response.error('db_error', `Failed to load the restrictions!`, err));
        }










        /**
        * creates new restrictions setting all required relations
        * in an easy way.
        */
        create(request, response) {


            // check if there is valid payload
            if (Array.isArray(request.data)) {

                Promise.all(request.data.map((restriction) => {


                    // make sure all resources exist
                    return Promise.all(restriction.resources.map((resource) => {
                        return this.db.resource({identifier: resource}).findOne().then((res) => {
                            if (!res) {
                                return new this.db.resource({
                                    identifier: resource
                                }).save();
                            } else return Promise.resolve(res);
                        });
                    })).then((resources) => {


                        // make sure all actions exist
                        return Promise.all(restriction.actions.map((action) => {
                            return this.db.action({identifier: action}).findOne().then((act) => {
                                if (!act) {
                                    return new this.db.action({
                                        identifier: action
                                    }).save();
                                } else return Promise.resolve(act);
                            });
                        })).then((actions) => {


                            // make sure the service exists
                            return this.db.service({identifier: restriction.service}).findOne().then((srv) => {
                                if (!srv) {
                                    return new this.db.service({
                                        identifier: restriction.service
                                    }).save();
                                } else return Promise.resolve(srv);
                            }).then((service) => {


                                // make sure all principal exits
                                return Promise.all((restriction.principals || []).map((principal) => {
                                    return this.db.principal({principalId: principal.id}).getPrincipalType({identifier: principal.type}).findOne().then((prin) => {
                                        if (!prin) {
                                            return new this.db.principal({
                                                  principalId: principal.id
                                                , principalType: this.db.principalType({
                                                    identifier: principal.type
                                                })
                                            }).save();
                                        } else return Promise.resolve(prin);
                                    });
                                })).then((principals) => {


                                    // create row restriction
                                    return this.db.rowRestriction('id', {
                                          identifier: restriction.identifier
                                        , id_service: service.id
                                    }).fetchAction('id').fetchResource('id').getPrincipal('id').findOne().then((existingRestriction) => {
                                        if (existingRestriction) {


                                            // add principals
                                            const existingPrincipals = new Set(existingRestriction.principal.map(p => p.id));
                                            principals.forEach((principal) => {
                                                if (!existingPrincipals.has(principal.id)) existingRestriction.principal.push(principal);
                                            });


                                            // add actions
                                            const existingActions = new Set(existingRestriction.action.map(a => a.id));
                                            actions.forEach((action) => {
                                                if (!existingActions.has(action.id)) existingRestriction.action.push(action);
                                            });


                                            // add resources
                                            const existingResources = new Set(existingRestriction.resource.map(r => r.id));
                                            resources.forEach((resource) => {
                                                if (!existingResources.has(resource.id)) existingRestriction.resource.push(resource);
                                            });


                                            return existingRestriction.save();
                                        }
                                        else {

                                            // create a new restriction  ...
                                            return new this.db.rowRestriction({
                                                  valueType     : this.db.valueType({identifier: restriction.valueType})
                                                , comparator    : this.db.comparator({identifier: restriction.comparator})
                                                , action        : actions
                                                , resource      : resources
                                                , service       : service
                                                , value         : {value: restriction.value}
                                                , identifier    : restriction.identifier
                                                , description   : restriction.description
                                                , property      : restriction.property
                                                , principal     : principals
                                                , nullable      : !!restriction.nullable
                                                , global        : !!restriction.global
                                            }).save();
                                        }
                                    });
                                });
                            });
                        });
                    });
                })).then((restrictions) => {

                    // done
                    response.created(restrictions.map(r => r.id));
                }).catch((err) => {
                    response.error('db_error', `Failed to create restriction(s)!`, err);
                });
            } else return response.badRequest('missing_payload', `Cannot create restriction, the payload is missing!`);
        }
    }
})();
