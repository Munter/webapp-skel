/*global require, module, process*/
/*jslint nomen:false, regexp:false*/
var http = require('http'),
    sys = require('sys'),
    _ = require('underscore'),
    error = module.exports = {};

function addError(errorDefinition) {
    var Constructor = function (debugInfo) {
        Error.call(this, this.msg);
        Error.captureStackTrace(this, Constructor);
        this.debugInfo = debugInfo;
    };
    sys.inherits(Constructor, Error);

    error[errorDefinition.name] = Constructor;

    Constructor.prototype.toString = function () {
        return this.msg + (this.debugInfo ? ", debug info = " + JSON.stringify(this.debugInfo) : '');
    };

    _.each(errorDefinition, function (value, key) {
        Constructor.prototype[key] = value;
    });

    if ('httpStatus' in errorDefinition) {
        error[errorDefinition.httpStatus] = Constructor;
    }
}

_.each(http.STATUS_CODES, function (msg, httpStatus) {
    httpStatus = parseInt(httpStatus, 10);
    // Only include 4xx and 5xx here.
    if (httpStatus < 400) {
        return;
    }

    // Invent a name by camel casing the usual message and removing non-alphabetical chars
    var name = msg.replace(/ ([a-z])/gi, function ($0, $1) {
        return $1.toUpperCase();
    }).replace(/[^a-z]/gi, '');

    addError({
        httpStatus: httpStatus,
        name: name,
        msg: msg
    });
});

error.normalize = function (err) {
    if (err instanceof Error) {
        // Already a OneWeb error
        return err;
    } else if ('httpStatus' in err && err.httpStatus in error) {
        // CouchDB, HTTP client library
        return new error[err.httpStatus](err);
    } else if ('errno' in err) {
        // File system operations
        switch (err.errno) {
        case process.EEXIST:
            return new error.Conflict();
        case process.ENOENT:
            return new error.NotFound();
        default:
            break;
        }
    }
    // Generic fallback
    return new error.InternalServerError(err);
};

error.passToFunction = function (next, successCallback) {
    return function (err) { // ...
        if (err) {
            next(err);
        } else if (successCallback) {
            successCallback.apply(this, [].slice.call(arguments, 1));
        }
    };
};

error.throwException = function (successCallback) {
    return function (err) { // ...
        if (err) {
            throw err;
        } else if (successCallback) {
            successCallback.apply(this, [].slice.call(arguments, 1));
        }
    };
};
