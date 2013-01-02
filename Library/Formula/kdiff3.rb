require 'formula'

class Kdiff3 < Formula
  homepage 'http://kdiff3.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.97/kdiff3-0.9.97.tar.gz'
  sha1 '1f2828c4b287b905bac64992b46a3e9231319547'

  depends_on 'qt'

  def install
    # configure builds the binary
    system "./configure", "qt4"
    bin.install "releaseQt/kdiff3.app/Contents/MacOS/kdiff3"
  end
end
