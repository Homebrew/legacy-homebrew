require 'formula'

class Gpsbabel <Formula
  url 'http://www.gpsbabel.org/plan9.php?dl=gpsbabel-1.3.6.tar.gz'
  homepage 'http://www.gpsbabel.org'
  md5 '1571b31f8f06f722995449dbff01ca49'

  depends_on 'libusb'
  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
