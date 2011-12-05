require 'formula'

class GitDiffall < Formula
  url 'https://github.com/thenigan/git-diffall.git'
  head 'https://github.com/thenigan/git-diffall.git'
  version 'head'
  homepage 'https://github.com/thenigan/git-diffall'
  md5 ''

  # depends_on 'git'

  def install
    bin.install('git-diffall')
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test git-diffall`. Remove this comment before submitting
    # your pull request!
    system "test -x /usr/local/bin/git-diffall"
  end
end
