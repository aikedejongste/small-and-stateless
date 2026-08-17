# charger-coverage

What share of Dutch motorway fuel stations also have an EV fast charger.
Moved here from the standalone `aikedejongste/fast-charger-coverage` repo.

Unlike the other apps here, this one is not a hand-written page: `index.html` is
a generated snapshot, produced by `run.sh` from OpenStreetMap data.

## Files

| File                  | What it is                                                        |
| --------------------- | ----------------------------------------------------------------- |
| `index.html`          | the published report — generator output, committed as a snapshot   |
| `run.sh`              | queries Overpass, counts the two sets, writes `output/index.html`  |
| `q-hw-gas-total.txt`  | Overpass query: fuel stations at/near NL motorways                 |
| `q-hw-gas-with-fc.txt`| Overpass query: those same stations that have a charging station   |

## Regenerating

`run.sh` needs `curl` and `jq`, and must be run from this directory — it reads
the query files by relative path:

```
cd charger-coverage && ./run.sh
```

It writes `output/index.html` (git-ignored). To publish a new report, copy that
file over `index.html` and commit it.

`.github/workflows/charger-coverage.yml` does the same thing on a manual
`workflow_dispatch` and uploads the result as a build artifact. It deliberately
does **not** deploy to Pages: `deploy.yml` ships the whole site, and publishing
from a second workflow would replace the site with this single page.

## Status

The generator does not currently work — the Overpass queries need fixing before
the numbers can be trusted. The two queries also don't select quite the same
thing (`q-hw-gas-total.txt` restricts to `motorway=yes` service areas and adds
stations within 75 m of a motorway way; `q-hw-gas-with-fc.txt` uses all service
and rest areas with 100 m radii), so the percentage compares two slightly
different populations. `index.html` is the last report that was published —
162 of 239 stations, 67.8%, collected 2025-10-08 — kept as-is.
