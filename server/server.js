/*jslint nomen:false, regexp:true*/
/*global module, require, __dirname, console, process*/
var express = require('express'),
    sys = require('sys'),
    fs = require('fs'),
    _ = require('underscore'),
    error = require('./modules/error');
    
    
function createServer (environment) {
    var app = module.exports = express.createServer();

    app.configure(function () {
        app.use(express.logger());
        if (app.set('gzip')) {
            app.use(express.gzip());
        }
        app.use(function (err, req, res, next) {
            if (err) {
                err = error.normalize(err);
                if (environment === 'development' && req.accepts('html')) {
                    // Let errors pass through in development mode to get a nice stack trace
                    return next(err);
                } else {
                    return res.send({error: err.msg}, {'Content-Type': 'application/json'}, err.httpStatus || 500);
                }
            } else {
                next();
            }
        });
    });

    if (environment === 'production') {
        app.use(express['static'](__dirname + '/../http-pub-production'));
        app.use(express.errorHandler());
    }

    if (environment === 'development') {
        app.use(express['static'](__dirname + '/../http-pub'));
        app.use(express.errorHandler({dumpExceptions: true, showStack: true}));
    }

    // Listen if invoked directly using the node executable:
    return app;
}

createServer('development').listen(3000);
createServer('production').listen(3001);

process.on('uncaughtException', function (e) {
    sys.error(e.stack);
});

