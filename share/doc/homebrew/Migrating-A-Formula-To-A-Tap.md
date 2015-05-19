# Migrating A Formula To A Tap
There are times when we may wish to migrate a formula from Homebrew's core (the main repository) into a tap (another repository). To do this:

1. Create a pull request to the new tap adding the formula file as-is from the main Homebrew repository. Fix any test failures that may occur due to the stricter requirements for new formulae than existing formula (e.g. `brew audit --strict` must pass for that formula).
2. Create a pull request to the main repository deleting the formula file and add it to `Library/Homebrew/tap_migrations.rb` with a commit message like `gv: migrating to homebrew/x11`.
3. Put a link for each pull request in the other pull request so the maintainers can merge them both at once.

Congratulations, you've moved a formula to a tap!
