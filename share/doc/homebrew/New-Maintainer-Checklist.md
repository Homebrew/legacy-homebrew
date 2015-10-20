# New Maintainer Checklist
**This is a guide used by existing maintainers to invite new maintainers. You might find it interesting but there's nothing here users should have to know.**

So, there's someone who has been making consistently high-quality contributions to Homebrew for a long time and shown themselves able to make slightly more advanced contributions than just e.g. formula updates? Let's invite them to be a maintainer!

First, send them the invitation email:

```
The Homebrew team and I really appreciate your help on issues, pull requests and
your contributions around $THEIR_CONTRIBUTIONS.

We would like to invite you to have commit access. There are no obligations,
but we'd appreciate your continuing help in keeping on top of contributions.

A few requests:

- please make pull requests on any changes to core (i.e. non-formula) code or
  any non-trivial (e.g. not a test or audit improvement or version bump)
  changes to formulae code and don't merge them unless you get at least one +1
- use `brew pull` and let it auto-close issues wherever possible (it may take
  ~5m). When this isn't possible always use `git pull --rebase`, `git rebase`
  and `git cherry-pick` rather than `git merge` and never use GitHub's "Merge
  pull request" button. If in doubt, check with GitX that you've not
  accidentally added merge commits
- still create your branches on your fork rather than in the main repository
- if still in doubt please ask for help and we'll help you out - these are
  probably worth a read:
    - https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Brew-Test-Bot-For-Core-Contributors.md
    - https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Maintainer-Guidelines.md
    - possibly everything else in the documentation

How does that sound?

Thanks for all your work so far!
```

If they accept, follow a few steps to get them set up:

- [x] Invite them to the [**@Homebrew/maintainers** team](https://github.com/orgs/Homebrew/teams/maintainers) to give them write access to all repositories (but don't make them owners yet)
- [x] Ask them to sign up for a [Bintray](https://bintray.com) account and invite them to [Bintray's Homebrew organisation](https://bintray.com/homebrew/organization/edit/members) as a member (but not administrator access yet) so they can publish new bottles
- [x] Add them to the [Jenkins' GitHub Authorization Settings admin user names](http://bot.brew.sh/configureSecurity/) so they can adjust settings and restart jobs
- [x] Add them to the [Jenkins' GitHub Pull Request Builder admin list](http://bot.brew.sh/configure) to enable `@BrewTestBot test this please` for them
- [x] Invite them to the [`homebrew-dev` private maintainers mailing list](https://groups.google.com/forum/#!managemembers/homebrew-dev/invite)
- [x] Invite them to the [`machomebrew` private maintainers Slack](https://machomebrew.slack.com/admin/invites)
- [x] Add them to [Homebrew's README](https://github.com/Homebrew/homebrew/edit/master/README.md)
- [x] Encourage them to enable [GitHub's Two Factor Authentication](https://help.github.com/articles/about-two-factor-authentication/)

After a few weeks/months with no problems consider making them [owners on the Homebrew GitHub organisation](https://github.com/orgs/Homebrew/people) and [administrators on Bintray](https://bintray.com/homebrew/organization/edit/members).

Now sit back, relax and let the new maintainers handle more of our contributions.
