# Project Templates (`direnv` + `just`)

This folder contains starter files for a project that follows the workflow in the root [README.md](../../README.md).

## Files

- `.envrc`: loads a local `.venv` (if present) and adds `bin/` to `PATH`
- `justfile`: defines baseline `just test`, `just lint`, `just format`, `just run`

## Usage

Copy into a project root:

```bash
cp /path/to/kamlab/templates/project/.envrc .
cp /path/to/kamlab/templates/project/justfile .
direnv allow
```

Then customize:

- `just run` entrypoint
- linter/formatter commands (e.g. `ruff`, `black`, `julia`, `npm`)
- project-specific environment variables

## Notes

- The template does not create environments automatically.
- This is intentional: keep environment creation explicit and project-specific.
