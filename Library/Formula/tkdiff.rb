require 'formula'

class Tkdiff < Formula
  url 'http://downloads.sourceforge.net/project/tkdiff/tkdiff/4.2/tkdiff-4.2.tar.gz'
  homepage 'http://tkdiff.sourceforge.net/'
  md5 'efc19226416afe3e98e4a29c112cfc3e'

  def install
    bin.install('tkdiff')
  end

  def test
    # Test that the executable runs
    system "#{bin}/tkdiff --help"
  end
end
