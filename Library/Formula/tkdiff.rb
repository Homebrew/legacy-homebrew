require 'formula'

class Tkdiff < Formula
  homepage 'http://tkdiff.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/tkdiff/tkdiff/4.2/tkdiff-4.2.tar.gz'
  md5 'efc19226416afe3e98e4a29c112cfc3e'

  def install
    bin.install 'tkdiff'
  end

  def test
    system "#{bin}/tkdiff", "--help"
  end
end
