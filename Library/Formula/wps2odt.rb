require 'formula'

class Wps2odt < Formula
  homepage 'http://libwps.sourceforge.net'
  url 'http://sourceforge.net/projects/libwps/files/wps2odt/wps2odt-0.2.0/wps2odt-0.2.0.tar.bz2'
  sha1 '94e1c911ee2dd4ddf262035c20721c09ca795831'

  depends_on 'libwps'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
