const CACHE = 'qwartz-v1';
self.addEventListener('install', e => e.waitUntil(
  caches.open(CACHE).then(c => c.addAll(['./']))
));
self.addEventListener('fetch', e => {
  if (e.request.url.includes('apibay.org')) return;
  e.respondWith(caches.match(e.request).then(r => r || fetch(e.request)));
});
