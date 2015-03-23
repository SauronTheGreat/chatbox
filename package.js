Package.describe({
  name: 'rushabhhathi:chatbox',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
    api.versionsFrom('1.0.2.1');
    var both = ['client', 'server'];

    api.use('coffeescript', both);
    api.use(['templating'], 'client');
    api.use('handlebars', 'client');
    //api.use("UI",'client');
    api.use('underscore', 'client');
    api.use(['mizzao:user-status@0.6.4','brentjanderson:buzz@1.1.9'],both);
    api.addFiles('collectionDefinitions.coffee');
    api.addFiles('server/servercode.coffee');
    api.addFiles('clientTemplates/chatPanel.html');

    api.addFiles('clientTemplates/chatPanel.coffee');
    api.addFiles('libFiles/profilePic.jpg');
    api.addFiles('libFiles/sounds/beep.mp3');



});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('rushabhhathi:chatbox');
  api.addFiles('chatbox-tests.js');
});
