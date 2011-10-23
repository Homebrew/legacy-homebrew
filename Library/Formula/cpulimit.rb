require 'formula'

class Cpulimit < Formula
  head 'https://cpulimit.svn.sourceforge.net/svnroot/cpulimit/trunk', :using=> :svn
  homepage 'http://cpulimit.sourceforge.net/'

  def install
    system "make"
    bin.install ['cpulimit']
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test cpulimit`. Remove this comment before submitting
    # your pull request!
    system "false"
  end
end
