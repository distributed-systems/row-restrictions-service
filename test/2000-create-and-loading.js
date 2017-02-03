(function() {
    'use strict';

    // donj't restrict permissions
    process.env.allowAll = true;


    const distributed               = require('distributed-prototype');
    const RelationalRequest         = distributed.RelationalRequest;
    const FilterBuilder             = distributed.FilterBuilder;
    const RowRestrictionsService    = require('../index');
    const config                    = require('./lib/relatedDBConfig');
    const log                       = require('ee-log');
    const assert                    = require('assert');




    const testService = new distributed.TestService();




    describe('Creating Restrictions', () => {
        it('preparing the app', (done) => {
            const app = new distributed.ServiceManager();

            app.registerService(new RowRestrictionsService({db: config.db}));
            app.registerService(testService);

            app.load().then(done).catch(done);
        });






        it('Creating a Restriction', function(done) {
            new RelationalRequest({
                  action: 'create'
                , service: 'row-restrictions'
                , resource: 'restriction'
                , data: [{
                      actions: ['create', 'read']
                    , resources: ['principal']
                    , service: 'eventData'
                    , valueType: 'function'
                    , comparator: 'gte'
                    , value: 'now()'
                    , name: 'make sure that stuff happens'
                    , description: ''
                    , property: 'created'
                    , global: true
                    , nullable: true
                    , principals: [{
                          id: 1221
                        , type: 'role'
                    }]
                }]
            }).send(testService).then((response) => {
                if (response.status === 'created') {
                    done();
                } else done(response.toError());
            }).catch(done);
        });






        it('Loading Restrictions', function(done) {
            new RelationalRequest({
                  action: 'list'
                , service: 'row-restrictions'
                , resource: 'restriction'
                , filter: new FilterBuilder().entity('service').property('identifier').comparator('=').value('eventData')
            }).send(testService).then((response) => {
                if (response.status === 'ok') {

                    assert.equal(!!response.data, true);
                    assert.equal(response.data.length, 1);

                    for (const data of response.data) {

                        assert.equal(!!data.principals, true);
                        assert.equal(data.principals.length, 1);

                        assert.equal(!!data.actions, true);
                        assert.equal(data.actions.length, 2);

                        assert.equal(!!data.resources, true);
                        assert.equal(data.resources.length, 1);


                        assert.equal(data.valueType, 'function');
                        assert.equal(data.comparator, 'gte');
                        assert.equal(data.service, 'eventData');
                        assert.equal(data.property, 'created');
                        assert.equal(data.value, 'now()');
                        assert.equal(data.nullable, true);
                        assert.equal(data.global, true);
                    }

                    done();
                } else done(response.toError());
            }).catch(done);
        });
    });
})();
