require 'formula'

class Cadaver <Formula
  url 'http://www.webdav.org/cadaver/cadaver-0.23.2.tar.gz'
  homepage 'http://www.webdav.org/cadaver/'
  md5 '5ac79e41f3b7b4f68bf4003beed5dc26'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl"
    system "(cd lib/intl; make)"
    system "make install"
  end
end
