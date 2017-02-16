(function() {
    'use strict';

    const distributed       = require('distributed-prototype');
    const RelatedService    = distributed.RelatedService;


    const Related           = require('related');
    const Timestamps        = require('related-timestamps');
    const log               = require('ee-log');



    const Restriction       = require('./controller/Restriction');



    module.exports = class RowRestrictionsService extends RelatedService {


        constructor(options) {

            // make sure the options exist and the service has a proper name
            options = options || {};

            // default name
            if (!options.name) options.name = 'row-restrictions';


            // super will load the controllers
            super(options);



            // db conectivity
            this.related = new Related(options.db);
            this.related.use(new Timestamps());


            // register tables that should
            // autoload its controllers
            this.autoLoad('action');
            this.autoLoad('comparator');
            this.autoLoad('resource');
            this.autoLoad('rowRestriction');
            this.autoLoad('service');
            this.autoLoad('valueType');
            this.autoLoad('principal');
            this.autoLoad('principalType');
            this.autoLoad('principal_rowRestriction');
        }






        // called before the related service loads
        // teh rest
        beforeLoad() {

            // load the db
            return this.related.load().then((db) => {
                this.db = db;

                const schema = this.db[this.dbName];


                this.resourceControllerOptions = {
                      db                    : db[this.dbName]
                    , Related               : Related
                    , dbName                : this.dbName
                };

                return Promise.resolve();
            });
        }






        afterLoad() {

            // load custom controllers
            this.registerResource(new Restriction(this.resourceControllerOptions));

            return Promise.resolve();
        }
    };
})();
