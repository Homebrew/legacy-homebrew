# Brew Test Bot For Core Contributors
If a build has run and passed on `brew test-bot` then it can be used to quickly bottle formulae.

There are three types of Jenkins jobs:

## Homebrew
This job automatically builds anything committed to the master branch. On failure it sends an email to `brew-test-bot@googlegroups.com`. It tests rather than builds bottles.

## Homebrew Pull Requests
This job automatically builds any pull requests submitted to Homebrew/homebrew. On success or failure it updates the pull request status (see more details on the [main Brew Test Bot wiki page](Brew-Test-Bot.md)). On a successful build it automatically uploads bottles.

## Homebrew Testing
This job is manually triggered to run [`brew test-bot`](https://github.com/Homebrew/homebrew/blob/master/Library/Homebrew/cmd/test-bot.rb) with user-specified parameters. On a successful build it automatically uploads bottles.

You can manually start this job with parameters to run [`brew test-bot`](https://github.com/Homebrew/homebrew/blob/master/Library/Homebrew/cmd/test-bot.rb) with the same parameters. It's often useful to pass a pull request URL, a commit URL, a commit SHA-1 and/or formula names to have `brew-test-bot` test them, report the results and produce bottles.

## Bottling
To pull and bottle a pull request with `brew pull`:

1. Ensure the job has already completed successfully.
2. Run `brew pull --bottle 12345` where `12345` is the pull request number (or URL). If it complains about a missing URL with `BrewTestBot` in it then the bottles have not finished uploading yet; wait and try again later.
3. Run `brew fetch --force-bottle $FORMULAE` to check the SHA-1 in the bottled formulae match the uploaded files.
4. Run `git push` to push the commits.

To bottle a test build or pull request without `brew pull`:

1. Ensure the job has already completed successfully.
2. For testing builds note the job number (e.g. `123`). For pull request builds note the pull request number (e.g. `45678`).
3. Run `git fetch --tags https://github.com/BrewTestBot/homebrew.git`
4. For testing builds run `git merge testing-123` (where `123` is the testing job number). For pull requests builds run `git merge pr-45678` (where `45678` is the pull request number).
5. Run `git rebase origin/master` to get rid of any nasty merge commits.
6. Run `brew fetch --force-bottle $FORMULAE` to check the SHA-1 in the bottled formulae match the uploaded files.
7. Run `git push` to push the commits.
