require 'formula'

class Gpsbabel <Formula
  url 'http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/gpsbabel-1.4.2.tar.gz'
  homepage 'http://www.gpsbabel.org'
  md5 '76ea9f7852be2e98aa18976c4697ca93'

  depends_on 'libusb'
  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
