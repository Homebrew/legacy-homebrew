require 'formula'

class Cadaver < Formula
  url 'http://www.webdav.org/cadaver/cadaver-0.23.3.tar.gz'
  homepage 'http://www.webdav.org/cadaver/'
  sha1 '4ad8ea2341b77e7dee26b46e4a8a496f1a2962cd'

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
