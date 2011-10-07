require 'formula'

class ColorCode < Formula
  url 'http://colorcode.laebisch.com/download/ColorCode-0.7.2.tar.gz'
  homepage 'http://colorcode.laebisch.com/'
  sha1 'd9ecd49d04c41ac680ae4d2cb217215440c1a27d'

  depends_on 'qt'

  def install
    system "qmake; make"
    prefix.install "ColorCode.app"
  end
end
