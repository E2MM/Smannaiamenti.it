'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "77c69ffeb93c0194703b1351dc8e5304",
"index.html": "f32ae0280e645b8619378faf8801f214",
"/": "f32ae0280e645b8619378faf8801f214",
"CNAME": "479540a8a9c9c49891e813d6ebfc256c",
"main.dart.js": "e028dbbba138c835ab5c25304dc6a339",
"favicon.png": "8702a79f97a14edb228f5db6fb4f1e6f",
"icons/Icon-200.png": "8702a79f97a14edb228f5db6fb4f1e6f",
"manifest.json": "906f2622021faaf37584df2895a5494f",
"assets/web/icons/Icon-200.png": "8702a79f97a14edb228f5db6fb4f1e6f",
"assets/AssetManifest.json": "14e849c07ef931034676c896a56c4ca5",
"assets/wiki/content.json": "6091a4fad016537363129de5b098023e",
"assets/wiki/bambin*.md": "882cf7e3d0264a0a08d58e2a18523a90",
"assets/wiki/porcisturo.md": "bec18232f7e3c5f604b0c442e7129d0e",
"assets/wiki/sistema_porcoidale.md": "552ea7e7e4e87fee6a840ed7f3c88f70",
"assets/wiki/content.md": "cebc4a5f4c16c8400af406397dd75425",
"assets/wiki/porcinuro.md": "a89313fdc7e3e4b8e064a05072d4d17f",
"assets/wiki/procupto.md": "eb9919c55731997387323857632de07b",
"assets/wiki/procuptide.md": "396a60e170eea740e19ece2d6748c08d",
"assets/wiki/rostro.md": "1b71de4ef230e75451955516bdf45db5",
"assets/wiki/defrastiare.md": "668d86ad5fe1c9b8c9f8580b5d6a89d7",
"assets/wiki/Home.md": "acef0c3d386c6b8583cee1b157a004d9",
"assets/wiki/porcide.md": "bbf25a74c39c6d00e1c66e0a9f31faf6",
"assets/wiki/ghktkuktk.md": "45fac8f707b883d15bc74b93fd34875b",
"assets/wiki/porciclico.md": "eb8500785e529c44d6d49f125d6b3074",
"assets/wiki/cranietto_rotto.md": "f72254930be7207c41f4656e1bedce06",
"assets/wiki/25_porcile.md": "edc7f520ce6ea394649ac1e74a078b22",
"assets/wiki/gerbult.md": "ca7de11888f8f6665155816ff5296edd",
"assets/wiki/mucca_orcomummia_cinghiale.md": "45fe169984ab331241d1abae07b38b21",
"assets/wiki/porcistide.md": "7521fb3a4b6e14564d1433e4869f1876",
"assets/NOTICES": "fc9737c6721d9dc1f97f86d479bc86c9",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
