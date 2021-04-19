'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "358d05c8423c995473a2ed0edc7da528",
"index.html": "45709b0e7592b68160800a2aece348fa",
"/": "45709b0e7592b68160800a2aece348fa",
"CNAME": "479540a8a9c9c49891e813d6ebfc256c",
"main.dart.js": "e0290c2118fbe00ecbcedbcb53047cd0",
"favicon.png": "8702a79f97a14edb228f5db6fb4f1e6f",
"icons/Icon-200.png": "8702a79f97a14edb228f5db6fb4f1e6f",
"manifest.json": "8cb874c5cccfd3c826e1c86e05cf9ad2",
".git/config": "63839a0bca73328eca0b99ce11190876",
".git/objects/pack/pack-defced5719194b0df10dd6b57c010ce743a9917d.pack": "fe45e9d2b98dbb5ca000154ca9fc55cd",
".git/objects/pack/pack-defced5719194b0df10dd6b57c010ce743a9917d.idx": "0f9694d20a4307ae255d00f65ddfa9e2",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/logs/HEAD": "286ac0c8e1c21bae2623764015aa0261",
".git/logs/refs/heads/gh-pages": "286ac0c8e1c21bae2623764015aa0261",
".git/logs/refs/remotes/origin/HEAD": "c7fa0e130dc09a3dddb2d75300b75420",
".git/refs/heads/gh-pages": "42ecb2ea37e3ff6438b5212f87166e0b",
".git/refs/remotes/origin/HEAD": "73a00957034783b7b5c8294c54cd3e12",
".git/index": "763e8d23f9ab7d8d4ba43814c8e6705d",
".git/packed-refs": "12f969ee93140935a721c732094fb0dd",
".git/FETCH_HEAD": "e34c1affa391410a02369454029b3409",
".git/sourcetreeconfig": "d97773dbac069e79ba454638c9b9b1dc",
"assets/web/icons/Icon-200.png": "8702a79f97a14edb228f5db6fb4f1e6f",
"assets/AssetManifest.json": "b0f32f9dd0e60cdbb86b3f3673aea1b5",
"assets/wiki/content.json": "1343e1bb48a90c93f5d4f21a9a755dbd",
"assets/wiki/content.md": "1343e1bb48a90c93f5d4f21a9a755dbd",
"assets/wiki/rostro.md": "1b71de4ef230e75451955516bdf45db5",
"assets/wiki/Home.md": "acef0c3d386c6b8583cee1b157a004d9",
"assets/wiki/porcide.md": "3d57b48022ef950e6bc7dc4ede74248c",
"assets/NOTICES": "d81c3df537f21c9a5fe4d19596ebd5c7",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/md/content.json": "1343e1bb48a90c93f5d4f21a9a755dbd",
"assets/md/rostro.md": "1b71de4ef230e75451955516bdf45db5",
"assets/md/porcide.md": "550f4ba0c4b2cc41bebf0486bfcd244e",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac"
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
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
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
