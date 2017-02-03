(function() {
    'use strict';

    // donj't restrict permissions
    process.env.allowAll = true;


    const RowRestrictionsService = require('../index');
    const config = require('./lib/relatedDBConfig');



    describe('Service', () => {
        it('Basic execution check', () => {
            new RowRestrictionsService({
                db: config.db
            });
        });
    });
})();
