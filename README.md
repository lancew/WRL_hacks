# Judo World Ranking list in Elm.
* https://www.judowrl.com/
* https://github.com/lancew/WRL_hacks

## Intro
This was originally written in JQuery in 2014, using the judobase API from the International Judo Federation (IJF).

Re-written in 2020 with Elm-lang.

## Dev environment

Run the app with hot reload etc.

 ```./node_modules/elm-go/bin/elm-go.js src/Main.elm -- --debug```

 ### Bumping dependencies
 * NPM : ```npm upgrade```
 * ELM : ```elm-json upgrade```

## Production environment

### Build

This code is accessed via the https://www.judowrl.com/ domain, but is hosted via github pages, so currently done via commiting the Elm generated index.html file to the repo.

```elm make src/Main.elm --optimize```

Then add, commit, and push index.html

### Hosting

Currently the site is served via Netlify.com

