# How To Open a Homebrew Pull Request (and get it merged)
The following commands are used by Homebrew's contributors to setup a fork of Homebrew's Git repository on GitHub, create a new branch and create a GitHub pull request of the changes in that branch.

To set up your own fork of the Homebrew repository:

1. Change to the directory containing your Homebrew installation with `cd $(brew --repository)`
2. [Fork the Homebrew repository](https://github.com/Homebrew/homebrew/fork) on GitHub. This creates a pushable, personal remote repository. This is needed as only Homebrew maintainers have push access to the main repository.
3. Add the pushable forked repository with `git remote add YOUR_USERNAME https://github.com/YOUR_USERNAME/homebrew.git`

To make a new branch and submit it for review:

1. Checkout the `master` branch with `git checkout master`
2. Retrieve new changes to the `master` branch with `brew update` (which calls `git pull`)
3. Create a new branch from the latest `master` branch with `git checkout -b YOUR_BRANCH_NAME origin/master`
4. Make your changes to any Homebrew formula with `brew edit` (following all the requirements in the [Formula Cookbook](Formula-Cookbook.md)). Run `brew audit ANY_CHANGED_FORMULA`, `brew tests` and `brew install ANY_CHANGED_FORMULA && brew test ANY_CHANGED_FORMULA` and ensure all of these pass without issue. If there's a `bottle do` block in the formula: don't remove it; we'll update it when we pull it.
5. Make a separate commit for each changed formula with `git add` and `git commit`.
6. Upload your new commits to the branch to your fork with `git push --set-upstream YOUR_USERNAME YOUR_BRANCH_NAME`
7. Go to https://github.com/Homebrew/homebrew and create a pull request to request review and merge of commits in your pushed branch. Make sure you explain why the change is needed and, if fixing a bug, how to reproduce the bug. Please note that the preferred commit message format for simple version updates is "FORMULA_NAME NEW_VERSION", e.g. "`source-highlight 3.1.8`". `devel` version bumps should have the commit message marked with addtional `(devel)` suffix like "`nginx 1.9.1 (devel)`". Await feedback or a merge from Homebrew's maintainers.

To respond well to feedback:

1. Ask for clarification of anything you don't understand and help with anything you don't know how to do.
2. Post a comment on your pull request if you've provided all the requested changes/information and it hasn't been merged after a week. Post a comment on your pull request if you're stuck and need help.
3. Keep discussion in the pull request unless requested otherwise (i.e. do not email maintainers privately).
4. Do not continue discussion in closed pull requests.
5. Do not argue with Homebrew maintainers. You may disagree but unless they change their mind please implement what they request. Ultimately they control what is included in Homebrew as they have to support any changes that are made.

To make changes based on feedback:

1. Checkout your branch again with `git checkout YOUR_BRANCH_NAME`
2. Make any requested changes and commit them with `git add` and `git commit`
3. Squash new commits into one commit per formula with `git rebase --interactive origin/master`
4. Push to the fork's remote branch and the pull request with `git push --force`

Once all feedback has been addressed and if it's a change we want to include (we include most changes) then we'll add your commit to Homebrew. Note it will not show up as "Merged" because of the way we include contributions.

Well done, you are now a Homebrew contributor!
