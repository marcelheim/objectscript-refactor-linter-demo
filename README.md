# objectscript-refactor-linter-demo

IRIS sample app used to try out `oto-lint`, an ObjectScript linter.

CI lints the `*.mac` routines under `src/` on every push and PR and uploads the
results as SARIF, so findings show up under Security → Code scanning and inline
on the diff.

Run it locally:

```sh
bin/oto-lint.linux --config=.oto-lint.json --format=text $(find src -name '*.mac')
```

Rules and severities live in `.oto-lint.json`. `.cls` classes aren't parsed yet.
