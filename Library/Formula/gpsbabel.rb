require 'formula'

class Gpsbabel <Formula
  url 'http://ee.archive.ubuntu.com/pub/pkgsrc/distfiles/gpsbabel-1.4.1.tar.gz'
  homepage 'http://www.gpsbabel.org'
  md5 '512c4acfb12e20102fa5ceacef45a356'

  depends_on 'libusb'
  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
