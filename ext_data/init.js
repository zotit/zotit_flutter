window.addEventListener('load', function (ev) {
    // Download main.dart.js
    _flutter.loader.loadEntrypoint({
      serviceWorker: {
      },
      onEntrypointLoaded: function (engineInitializer) {
        engineInitializer.initializeEngine().then(function (appRunner) {
          appRunner.runApp();
        });
      }
    });
  });
  setTimeout(()=>{document.body.style.setProperty("position","unset") },500)