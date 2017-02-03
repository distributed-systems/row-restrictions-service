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

            const query = this.db.rowRestriction('*');

            // filter by service?
            if (serviceName) query.getService({identifier: serviceName});

            query.getAction('identifier');
            query.getResource('identifier');
            query.getValueType('identifier');
            query.getComparator('identifier');
            query.getService('identifier');
            query.getPrincipal('*').getPrincipalType('identifier');

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
                const transaction = this.db.createTransaction();

                Promise.all(request.data.map((restriction) => {


                    // make sure all resources exist
                    return Promise.all(restriction.resources.map((resource) => {
                        return transaction.resource({identifier: resource}).findOne().then((res) => {
                            if (!res) {
                                return new transaction.resource({
                                    identifier: resource
                                }).save();
                            } else return Promise.resolve(res);
                        });
                    })).then((resources) => {


                        // make sure all actions exist
                        return Promise.all(restriction.actions.map((action) => {
                            return transaction.action({identifier: action}).findOne().then((act) => {
                                if (!act) {
                                    return new transaction.action({
                                        identifier: action
                                    }).save();
                                } else return Promise.resolve(act);
                            });
                        })).then((actions) => {


                            // make sure the service exists
                            return transaction.service({identifier: restriction.service}).findOne().then((srv) => {
                                if (!srv) {
                                    return new transaction.service({
                                        identifier: restriction.service
                                    }).save();
                                } else return Promise.resolve(srv);
                            }).then((service) => {


                                // make sure all pricinpials exits
                                return Promise.all((restriction.principals || []).map((principal) => {
                                    return transaction.principal({principalId: principal.id}).getPrincipalType({identifier: principal.type}).findOne().then((prin) => {
                                        if (!prin) {
                                            return new transaction.principal({
                                                  principalId: principal.id
                                                , principalType: transaction.principalType({
                                                    identifier: principal.type
                                                })
                                            }).save();
                                        } else return Promise.resolve(prin);
                                    });
                                })).then((principals) => {


                                    // rceate the restirction already ...
                                    return new transaction.rowRestriction({
                                          valueType     : transaction.valueType({identifier: restriction.valueType})
                                        , comparator    : transaction.comparator({identifier: restriction.comparator})
                                        , action        : actions
                                        , resource      : resources
                                        , service       : service
                                        , value         : {value: restriction.value}
                                        , name          : restriction.name
                                        , description   : restriction.description
                                        , property      : restriction.property
                                        , principal     : principals
                                        , nullable      : !!restriction.nullable
                                        , global        : !!restriction.global
                                    }).save();
                                });
                            });
                        });
                    });
                })).then((restrictions) => {

                    // commit
                    return transaction.commit().then(() => {

                        // done
                        response.created(restrictions.map(r => r.id));
                    });
                }).catch((err) => {

                    // roll back but dont wait for that
                    transaction.rollback();

                    response.error('db_error', `Failed to create restriction(s)!`, err);
                });
            } else return response.badRequest('missing_payload', `Cannot create restriction, the payload is missing!`);
        }
    }
})();
