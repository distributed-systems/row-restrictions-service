(function() {
    'use strict';


    let config = require('./dbConfig');


    module.exports = {
        db: {
              type      : 'postgres'
            , database  : config.database
            , schema    : 'row_restriction_service'
            , hosts     : [{
                  host           : config.host
                , username       : config.user
                , password       : config.pass
                , maxConnections : 10
                , pools          : ['write', 'read', 'master']
            }]
        }
    };
})();
