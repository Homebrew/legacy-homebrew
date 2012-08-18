require 'formula'

class Kdiff3 < Formula
  url 'http://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.97/kdiff3-0.9.97.tar.gz'
  homepage 'http://kdiff3.sourceforge.net/'
  md5 '30a71b474956c369ed7b38c6db080fc4'

  depends_on 'qt'

  def install
    # configure builds the binary
    system "./configure", "qt4"
    bin.install "releaseQt/kdiff3.app/Contents/MacOS/kdiff3"
  end
end
