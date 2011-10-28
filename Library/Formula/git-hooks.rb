require 'formula'

class GitHooks < Formula
  head 'git://github.com/icefox/git-hooks.git'
  homepage 'https://github.com/icefox/git-hooks'

  def install
    $home = ENV['HOME']
    $githooks_userdir = "#{$home}/.git_hooks"
    
    #
    # create the user scoped .git_hooks directory, as well as placeholder subdirectories
    #
    hooks = %w[
      applypatch-msg
      pre-applypatch
      post-applypatch
      pre-commit
      prepare-commit-msg
      commit-msg
      post-commit
      pre-rebase
      post-checkout
      post-merge
      pre-receive
      update
      post-receive 
      ]
    hooks.each do |hook|
      mkdir_p "#{$githooks_userdir}/#{hook}"
    end
    
    #
    # install the binary
    #
    bin.install 'git-hooks'
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test git-hooks`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
