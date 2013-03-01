require 'formula'

class Dar < Formula
  homepage 'http://dar.linux.free.fr/doc/index.html'
  url 'http://sourceforge.net/projects/dar/files/dar/2.4.9/dar-2.4.9.tar.gz'
  sha1 '0045983277a1a1c3148ca22837f992032baf9509'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-build-html"
    system "make install"
  end
end
