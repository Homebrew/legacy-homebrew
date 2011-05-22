require 'formula'

class Kdiff3 < Formula
  url 'http://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.95/kdiff3-0.9.95.tar.gz'
  homepage 'http://kdiff3.sourceforge.net/'
  md5 '652a98bf79ba762a8a646d4a0fddb323'

  depends_on 'qt'

  def install
    system "./configure", "qt4"
    bin.install "src-QT4/kdiff3.app/Contents/MacOS/kdiff3"
  end
end
