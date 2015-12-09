# Renaming a Formula

Sometimes software and formulae need to be renamed. To rename core formula
you need to:

1. Rename the formula file and its class to a new formula. The new name must meet all the usual rules of formula naming. Fix any test failures that may occur due to the stricter requirements for new formulae than existing formulae (i.e. `brew audit --strict` must pass for that formula).

2. Create a pull request to the main Homebrew repository deleting the old formula file, adding the new formula file and add it to `Library/Homebrew/formula_renames.rb` with a commit message like `newack: renamed from ack`

To rename tap formulae you need to follow the same steps but add formulae to `formula_renames.json` in the root of your tap. You don't need to change `Library/Homebrew/formula_renames.rb`, because that file is for Homebrew core formulae only. Use canonical name (e.g. `ack` instead of `user/repo/ack`).

A `Library/Homebrew/formula_renames.rb` example for a core formula rename:

```ruby
FORMULA_RENAMES = {
  "ack" => "newack"
}
```

A `formula_renames.json` example for a tap formula rename:

```json
{
  "ack": "newack"
}
```
