require 'formula'

class Tkdiff < Formula
  url 'http://downloads.sourceforge.net/project/tkdiff/tkdiff/4.2/tkdiff-4.2.tar.gz'
  homepage 'http://tkdiff.sourceforge.net/'
  md5 'efc19226416afe3e98e4a29c112cfc3e'

  def install
    bin.install('tkdiff')
  end

  def test
    # It's enough to just replace "false" with the main program this
    # formula installs, but it'd be nice if you were more thorough.
    # Test the test with `brew test tkdiff`.
    system "tkdiff --help"
  end
end
