# small-and-stateless

A collection of tiny web apps, hosted on GitHub Pages at
**www.aikedejongste.nl**. Almost every app is one self-contained `index.html` in
its own directory — no bundler, no backend, no shared assets. The one exception
is `longwaylanta/`, a Hugo site that gets built during deployment.

## Layout

```
index.html          landing page — links to every listed app
robots.txt          allows crawling of the landing page only
CNAME               custom domain for Pages
<app>/index.html    one directory per app
_<app>/index.html   unlisted app (see below)
longwaylanta/       Hugo source — built, not copied (see below)
dist/               build output, git-ignored, created by the workflow
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

## No pull requests

Commit straight to `main` and push. Don't open a PR, and don't work on a branch
unless asked to — this is a one-person repo and review adds nothing. Since every
push to `main` deploys, check the change locally first (see below).

## Deployment

`.github/workflows/deploy.yml` runs on every push to `main`, plus manual
`workflow_dispatch`. It assembles `dist/` rather than shipping the repo as-is:

1. copy the repo into `dist/`, minus `.git`, `.github`, `dist` and `longwaylanta`
2. build `longwaylanta/` with Hugo straight into `dist/longwaylanta`
3. upload `dist/` as the Pages artifact

So a static app ships exactly as committed, and the Hugo source never ends up
served. Anything new that needs a build stage gets added to step 2 the same way.

## The Hugo site (`longwaylanta/`)

Served at `/longwaylanta/`, a subpath rather than its own domain, which is the
thing most likely to break. `longwaylanta/CLAUDE.md` has the details; the short
version is that `baseURL` in `hugo.toml` carries the `/longwaylanta/` path and
templates must never build a URL from a leading-slash string.

## Checking changes locally

Static apps:

```
python3 -m http.server 8000
```

The whole site including the Hugo build — this mirrors what CI does, so use it
whenever you touch `longwaylanta/` or the workflow:

```
mkdir -p dist
tar -cf - --exclude=./.git --exclude=./.github --exclude=./dist \
          --exclude=./longwaylanta . | tar -xf - -C dist
hugo --gc --minify --source longwaylanta --destination "$PWD/dist/longwaylanta"
(cd dist && python3 -m http.server 8000)
```

Then click through each app — this matches how Pages serves directory URLs. Apps
that use a CDN (Leaflet, React) or map tiles need network access to render.
