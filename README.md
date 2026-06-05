# objectscript-refactor-linter-demo

A small InterSystems IRIS app that runs Conway's Game of Life (the two-colour
"immigration" variant) twice — once with a **modern**, structured ObjectScript
engine and once with a **legacy** one. Both produce the exact same generations;
the web UI runs them side by side and flags any divergence.

The point is the gap in *how* they're written. `oto-lint` runs over the `.mac`
routines in CI on every push and PR and uploads SARIF, so findings show up under
Security → Code scanning and inline on the diff.

```
src/life/LifeModern.mac    structured engine   (clean)
src/life/LifeClassic.mac   legacy engine       (goto / xecute / kill / postconditionals)
src/web/LifeWeb.cls         amber-terminal UI + JSON endpoints
```

Lint locally:

```sh
bin/oto-lint.linux --config=.oto-lint.json --format=text $(find src -name '*.mac')
```

Enabled rules and severities live in `.oto-lint.json`. `.cls` classes aren't
parsed yet, so the UI class is not linted.
