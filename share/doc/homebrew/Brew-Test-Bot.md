# Brew Test Bot
`brew test-bot` is the name for the automated review and testing system funded
by [our Kickstarter in 2013](https://www.kickstarter.com/projects/homebrew/brew-test-bot).

It comprises of four Mac Minis running in a data centre in England which host
[a Jenkins instance at http://bot.brew.sh](http://bot.brew.sh) and run the
[`brew-test-bot.rb`](https://github.com/Homebrew/homebrew/blob/master/Library/Homebrew/cmd/test-bot.rb)
Ruby script to perform automated testing of commits to the master branch, pull
requests and custom builds requested by maintainers.

## Pull Requests

The bot automatically builds pull requests and updates their status depending
on the result of the job.

For example, a job which has been queued but not yet started will have a
section in the pull-request that looks like this:


![Triggered Pull Request](images/brew-test-bot-triggered-pr.png)

---

A failed build looks like this:


![Failed Pull Request](images/brew-test-bot-failed-pr.png)

---

A passed build looks like this:


![Passed Pull Request](images/brew-test-bot-passed-pr.png)

---

On failed or passed builds you can click the "Details" link to view the result
in Jenkins.

When you click this you'll see the results.

A passed build looks like this:


![Passed Jenkins Build](images/brew-test-bot-passed-jenkins.png)

---

A failed build looks like this:


![Failed Jenkins Build](images/brew-test-bot-failed-jenkins.png)

---

You can click the test results link
(e.g. `brew-test-bot.Homebrew/homebrew/pull/22183-3c17deb.install embree`) to
view the failed test output:

![Failed Test](images/brew-test-bot-failed-test.png)

---
