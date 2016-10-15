require 'formula'

class GitHooks < Formula

  homepage 'https://github.com/icefox/git-hooks'
  url 'https://github.com/icefox/git-hooks.git', :revision => '26b0acd16d72105de831647faf0bdc09f2f0d062'
  head 'https://github.com/icefox/git-hooks.git'
  sha1 '52b6e33f9d8568a916cea5ba34813f8e2a7e2a99'

  def install
    bin.install "git-hooks"
  end

  def caveats
    <<-EOS.undent
      Run 'git hooks --install' Inside a git project to change that projects
      git hooks to use git-hooks hooks.  'git hooks --uninstall' can be run at
      any time to go back to the old hooks that were installed before
      (typically the default which does nothing).

      Run 'git hooks --installglobal' to force any new git repository or any
      git repository you clone to have a reminders to install git hooksi. (It
      can't be on by default for security reasons of course)
    EOS
  end

end
