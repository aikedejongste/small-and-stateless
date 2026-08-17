# Long Way Lanta

A website documenting a motorbike trip by two friends from Den Bosch (Maaspoort,
Netherlands) to Koh Lanta (Kohub, Thailand). The site presents the plan before and
during the trip.

## Tech

- Static site built with **Hugo** (extended edition).
- Live at **https://www.aikedejongste.nl/longwaylanta** — use this as `baseURL` in the Hugo config.
- Custom design — nice, clean look. Prefer a custom theme in `layouts/` and
  `assets/` over a third-party theme, so the design stays under our control.
- The route map should be interactive (e.g. Leaflet/MapLibre with OpenStreetMap
  tiles) and load without an API key. Route data lives in the repo as
  GeoJSON/GPX so it can be edited and versioned.

## Page structure (single landing page, top to bottom)

1. **Map** — opens with a full-width map showing the route from Maaspoort,
   Den Bosch to Kohub, Koh Lanta, with the planned stops marked.
2. **Day-to-day plan** — the itinerary, one entry per day: date, from → to,
   distance, notes. Authored as content files (one file or page per day) so days
   are easy to add and reorder.
3. **The bikes** — information about the two motorbikes (make/model, plates,
   prep, luggage setup).
4. **Stops along the way** — highlights of places we stop, linked to the map
   markers where possible.
5. **FAQ ("Questions & decisions")** — an index of cards on the homepage (and at
   `/faq/`), each linking to a full page per question under `content/faq/`.
   Answers are long-form, so they get their own pages rather than inline
   accordions. Each entry's front matter carries a one-line `summary` (shown on
   the index) and a `weight` for ordering.

## Content conventions

- Content in Markdown under `content/`; structured data (route, stops, bike
  specs) in `data/` where that's cleaner than front matter.
- Write FAQ answers in the same voice as the entry below: direct, reasoned,
  documenting the *decision* and the *why*.

## FAQ entries

The entries themselves live in `content/faq/` (one file per question); don't
duplicate their text here. Current entries:

- `dutch-plate.md` — "NL to Thailand or Thailand to Netherlands?" (why the bike
  wears a Dutch plate)
- `how-long-in-thailand.md` — "How long can the Dutch bike drive around
  Thailand?" (FVP/TIP clocks and the calendar-year trick)
