require 'formula'

class Wps2odt < Formula
  homepage 'http://libwps.sourceforge.net'
  url 'http://sourceforge.net/projects/libwps/files/wps2odt/wps2odt-0.2.0/wps2odt-0.2.0.tar.bz2'
  md5 '32c91f7b1f241ad96154643b046fd264'

  depends_on 'libwps'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
