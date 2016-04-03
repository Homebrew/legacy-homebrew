# Renaming a Formula

Sometimes software and formulae need to be renamed. To rename a formula
you need to:

1. Rename the formula file and its class to a new formula. The new name must meet all the usual rules of formula naming. Fix any test failures that may occur due to the stricter requirements for new formulae than existing formulae (i.e. `brew audit --strict` must pass for that formula).

2. Create a pull request to the corresponding tap deleting the old formula file, adding the new formula file, and adding it to `formula_renames.json` with a commit message like `newack: renamed from ack`. Use the canonical name (e.g. `ack` instead of `user/repo/ack`).


A `formula_renames.json` example for a formula rename:

```json
{
  "ack": "newack"
}
```
