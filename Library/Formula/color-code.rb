require 'formula'

class ColorCode < Formula
  url 'http://test.laebisch.com/ColorCode-0.5.5.tar.gz'
  homepage 'http://colorcode.laebisch.com/'
  md5 'f41657dccdb9305c3b5532f701067630'

  depends_on 'qt'

  def install
    system "qmake; make"
    prefix.install "ColorCode.app"
  end
end
