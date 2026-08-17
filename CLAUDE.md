# small-and-stateless

A collection of tiny single-page web apps, hosted on GitHub Pages at
**www.aikedejongste.nl**. Each app is one self-contained `index.html` in its own
directory — no build step, no bundler, no backend, no shared assets.

## Layout

```
index.html          landing page — links to every listed app
robots.txt          allows crawling of the landing page only
CNAME               custom domain for Pages
<app>/index.html    one directory per app
_<app>/index.html   unlisted app (see below)
```

## Directories starting with `_` are unlisted

A leading underscore (e.g. `_party-flier`) means the app is **deliberately kept
off the landing page**. When adding new apps to `index.html`, skip these — do not
add a card for them, and do not "helpfully" restore one that was removed.

Note that unlisted is not the same as private: `_` directories are still uploaded
by the deploy workflow and remain reachable at their URL by anyone who knows it.
`robots.txt` keeps them out of search results, but nothing more. If something
genuinely must not be public, it does not belong in this repo.

## Adding an app to the landing page

Add an `<a class="app">` card inside `<main class="apps">` in `index.html`,
following the shape of the existing ones: title, `/path` label, a couple of
sentences, and three tags. Two conventions matter:

- **Links must be relative** (`hoods/`, not `/hoods/`). Absolute paths break on
  the `aikedejongste.github.io/small-and-stateless/` project URL, which is what
  serves the site whenever the custom domain isn't resolving.
- **Descriptions should be accurate about the app**, including counts (number of
  rules, words, places). Read the app before describing it rather than guessing
  from the directory name.

## Deployment

`.github/workflows/deploy.yml` uploads the repo root and deploys to Pages on
every push to `main`, plus manual `workflow_dispatch`. There is no build stage,
so whatever is committed is what ships. `.git` and `.github` are excluded from
the artifact automatically.

## Checking changes locally

```
python3 -m http.server 8000
```

Then open `http://localhost:8000/` and click through to each app — this matches
how Pages serves directory URLs. Apps that use a CDN (Leaflet, React) or map
tiles need network access to render.
