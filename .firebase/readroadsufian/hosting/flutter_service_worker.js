'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "bb888b33bfaed81ef499e32d77a6f2de",
"assets/AssetManifest.bin.json": "3af3f16299cad858aa33d0d82925f182",
"assets/AssetManifest.json": "b6bd43218bd9208c5e0b3717af9ad9f4",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "794143b20d9485760028d3b3a7d87fae",
"assets/lib/Icons/0.png": "9b4e74ffdf49b9d3e937ece22f57c32d",
"assets/lib/Icons/1.png": "027a0872add0f02589ef0f514ad48788",
"assets/lib/Icons/10.png": "a70622d4d87b75f50810a5600490f6d7",
"assets/lib/Icons/11.png": "e987f3552ca78a955cb8eb5178418689",
"assets/lib/Icons/12.png": "2be072501cd0b2faab7f03337e738576",
"assets/lib/Icons/13.png": "ea8e039c3abd3cac5ce555ce3a8751df",
"assets/lib/Icons/14.png": "b9103ce3d4e21d1483d40c94cf513d02",
"assets/lib/Icons/15.png": "1bd9b4349d4a7cfc4640ee83c1519776",
"assets/lib/Icons/16.png": "1123d05e8a47a480cebb1e2ab275479e",
"assets/lib/Icons/17.png": "9210824ce3cc78c3152defa8b73d17fd",
"assets/lib/Icons/18.png": "0ee758df90396e21328336fd66d2f57e",
"assets/lib/Icons/19.png": "08027aba31da2a93c91962866ec99689",
"assets/lib/Icons/1Star.png": "a41101419b8754bf0fa0f90348c56cb4",
"assets/lib/Icons/2.png": "2363113a28d930953210b89cde16e8f5",
"assets/lib/Icons/20.png": "223fc61812993945f756f91ceb157660",
"assets/lib/Icons/21.png": "082d14d17b6306b6641ddc05a3e0150d",
"assets/lib/Icons/22.png": "2df143731a3a4608b7617a2cb3aa8343",
"assets/lib/Icons/23.png": "e66f5e3a0bdc60d63e23fc7fbbaea26e",
"assets/lib/Icons/24.png": "d974c48373845ca84969330eb74f4c5f",
"assets/lib/Icons/2Star.png": "40747ef02bbaf29dc95e67eaa61c46b2",
"assets/lib/Icons/3.png": "12c8293d93b9fcee86c3f900a094df14",
"assets/lib/Icons/3Star.png": "fd9f8e3f4f38f9d7c51118431fbeb600",
"assets/lib/Icons/4.png": "f4ebcb8c3f85b842cda0b231be25130c",
"assets/lib/Icons/4Star.png": "177de16eed5c387174f8b6a581c7b458",
"assets/lib/Icons/5.png": "a863dab6582ba16b2f17da298af09fbe",
"assets/lib/Icons/5Star.png": "7d087518ac35087d60e3d7e7f88dde2d",
"assets/lib/Icons/6.png": "65aff260366a53edee54da7c61e8cf74",
"assets/lib/Icons/7.png": "f8debcc1bd7f0d35ea7aa8e31a30d40c",
"assets/lib/Icons/8.png": "13348a2f9662b2e7257c78b5307498a0",
"assets/lib/Icons/9.png": "9c1a0479e6069add115315e7fe6712f3",
"assets/lib/Icons/AddedBook.png": "cfa4201e7208f4852746fa2f6510fe7d",
"assets/lib/Icons/author.png": "e1d5cb1c2f911a0ba321a33d3b34cc83",
"assets/lib/Icons/blackBook.png": "6c6db049d3d344c0ce9bc68b0caaae68",
"assets/lib/Icons/book.png": "fb07f8258db8722a0feba37398e3cc87",
"assets/lib/Icons/bookEdit.png": "b01f46723048755e4f1f2921d135cade",
"assets/lib/Icons/bookSearch.png": "4fb22d209265cec6e5daeac6e92aa0f6",
"assets/lib/Icons/contract.png": "d433243d8021d53dc4891e6861e1d2f3",
"assets/lib/Icons/cover1.jpeg": "ec38b29f23a117f29ac339e687715cdb",
"assets/lib/Icons/cover2.jpg": "97de6a7c0d8ef51c5a2d04be32ac66bd",
"assets/lib/Icons/cover3.jpg": "30ac51b8613aa3b4e2a52bdd47e24ed8",
"assets/lib/Icons/cover4.jpg": "cecc0d24519c6959107b372b63f84deb",
"assets/lib/Icons/cover5.jpg": "80da48bf9709ab4bf261d1edd81788ff",
"assets/lib/Icons/cover6.jpg": "db6c71a56c0604e3e2b029c2466a5a3b",
"assets/lib/Icons/cover7.jpg": "963ac9b2dad825abe2fb67bc27d309e5",
"assets/lib/Icons/genres.png": "b5ce779da357fa7d4d25fa829f11d7b8",
"assets/lib/Icons/notAdded.png": "8af58221d35e9d00b529af0232aac90c",
"assets/lib/Icons/openBook.png": "3f186601c7c92375b07f3f57a22431bb",
"assets/lib/Icons/post.png": "3581fae73b9aa59c81fb066e2a9d4522",
"assets/lib/Icons/PostIcon.png": "b8c08d97d75bc91ad8b5e2111b416e45",
"assets/lib/Icons/readLater.png": "3110d520a50547ebeeb0d62fd109c5cb",
"assets/lib/Icons/serachByBook.png": "792fac6ce28b7d4a68868efb657b5845",
"assets/lib/Icons/stackBook.png": "a22b61d54fda674e6b7a1fa4ef58c48d",
"assets/lib/Icons/thought.png": "6f778bb29efba252873cd9a8b548aa10",
"assets/lib/Icons/ThoughtOff.png": "f7486f103719c535f9dcd737e12beba6",
"assets/lib/Icons/ThoughtOn.png": "e4b6161971a91ff3fd5d132a816bfda4",
"assets/NOTICES": "36ae0a03da5bb0f7ee4f6679b3c13082",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "bce8d011dd231295b127ee7a182c742e",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "2bd7916ed2c4cc41cb8461f88eeae9bb",
"/": "2bd7916ed2c4cc41cb8461f88eeae9bb",
"main.dart.js": "f9092de0adec80fef75fe5ddec3c94cb",
"manifest.json": "89d562e0a605cee014fd475815b504ea",
"version.json": "500fec8946e79e2fa21808d30205720d"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
