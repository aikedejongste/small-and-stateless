(function () {
  var el = document.getElementById('route-map');
  if (!el || typeof L === 'undefined') return;

  var map = L.map(el, { scrollWheelZoom: false });
  map.on('click', function () { map.scrollWheelZoom.enable(); });

  L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);

  var stops = JSON.parse(document.getElementById('stops-data').textContent);
  var stopBounds = L.latLngBounds(stops.map(function (s) { return [s.lat, s.lon]; }));

  stops.forEach(function (s) {
    L.circleMarker([s.lat, s.lon], {
      radius: 6, color: '#b34a1d', weight: 2, fillColor: '#fff', fillOpacity: 1
    }).addTo(map).bindPopup(
      '<strong>' + s.name + '</strong><br>' + s.blurb +
      (s.gmaps ? '<br><a href="' + s.gmaps + '" target="_blank" rel="noopener">Google Maps ↗</a>' : '')
    );
  });

  fetch(el.dataset.route)
    .then(function (r) { return r.json(); })
    .then(function (geo) {
      var layer = L.geoJSON(geo, {
        style: function (f) {
          return f.properties && f.properties.status === 'open'
            ? { color: '#8a8577', weight: 3, dashArray: '6 9' }
            : { color: '#d95f2b', weight: 3.5 };
        }
      }).addTo(map);
      map.fitBounds(layer.getBounds().extend(stopBounds), { padding: [36, 36] });
    })
    .catch(function () {
      map.fitBounds(stopBounds, { padding: [36, 36] });
    });
})();
