About
=====

This is a webapp skeleton directory that can be used as a template to start new webapp projects with `assetgraph-builder <https://github.com/One-com/assetgraph-builder>`_ and `Ext JS <https://github.com/One-com/Ext-JS-4>`_

Installation
============

Run `bootstrap.sh <webapp-skel/bootstrap.sh>`_ to install all dependencies.
This will do a git checkout of nodejs in your home directory and build it, install npm, install required debian packages and install `assetgraph-builder <https://github.com/One-com/assetgraph-builder>`_.

Please do read the content of `bootstrap.sh <webapp-skel/bootstrap.sh>`_ before running it.

Keep your installation up to date with ``npm update`` after you've updated `package.json <webapp-skel/package.json>`_ with your desired assetgraph-builder version.

Ext JS is included as a submodule and set up to work with your web apps

Directory Structure
===================

http-pub
--------
This is where your development version of the webapp resides.
Put all your public assets in here and include them the way you normally do, or with ``one.include('filename')`` to use the assetgraph dependency system.
``make development`` will update the dependencies

http-pub/index.html.template
----------------------------
All html files in your development version should have ``.template`` appended to them.
The build system will produce a development version with the proper dependencies resolved and place them in your file name without ``.template``.
Remember to add html files you want built into the ``PAGES`` variable in `Makefile <webapp-skel/Makefile>`_

http-pub/3rdparty/
------------------
This is where external dependencies, like javascript or css frameworks, or your own library will be placed.
Per default Ext JS is checked in so you have a reference.
When you set up any new external library and you want to include things from it using labels in assetgraph, remember to define a label in ``LABELS`` in `Makefile <webapp-skel/Makefile>`_

If you want to get ExtJS in http-pub/3rdparty/ExtJS, simply run these commands in your webapp-skel top directory:
	git submodule init
	git submodule update

http-pub-production
-------------------
This is where the minified production build of your web application will be placed.
Static files will be concatenated, minified, renamed to an md5-hash of their content and placed in http-pub-production/static

http-pub-cdn
------------
Exactly like http-pub-production, except that static files are now assumed to be on ``CDN_ROOT`` as defined in `Makefile <webapp-skel/Makefile>`_.
Remember to copy your static files there if you are using a CDN.


Assetgraph
==========
The build system used in this setup is `Assetgraph-builder <https://github.com/One-com/assetgraph-builder>`_.
It uses `Assetgraph <https://github.com/One-com/assetgraph>`_ and `Assetgraph-sprite <https://github.com/One-com/assetgraph-sprite>`_.
Please read the documentation of those two projects to make the best use of all the automated build features available in Assetgraph-builder.
