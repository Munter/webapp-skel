Ext.application({
    name: 'MyApp',
    launch: function() {
        Ext.create('Ext.container.Viewport', {
            items: {
                html: 'My App'
            }
        });
    }
});