# Renaming a Formula

Sometimes software and formulae need to be renamed. To rename core formula
you need:

1. Rename formula file and its class to new formula. New name must meet all the rules of naming. Fix any test failures that may occur due to the stricter requirements for new formula than existing formula (e.g. brew audit --strict must pass for that formula).

2. Create a pull request to the main repository deleting the formula file, adding new formula file and also add it to `Library/Homebrew/formula_renames.rb` with a commit message like `rename: ack -> newack`

To rename tap formula you need to follow the same steps, but add formula to `formula_renames.json` in the root of your tap. You don't need to change `Library/Homebrew/formula_renames.rb`, because that file is for core formulae only. Use canonical name (e.g. `ack` instead of `user/repo/ack`).

`Library/Homebrew/formula_renames.rb` example for core formula renames:

```ruby
FORMULA_RENAMES = {
  "ack" => "newack"
}
```

`formula_renames.json` example for tap:

```json
{
  "ack": "newack"
}
```
