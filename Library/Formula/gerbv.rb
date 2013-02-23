require 'formula'

class Gerbv < Formula
  homepage 'http://gerbv.gpleda.org/'
  url 'http://downloads.sourceforge.net/project/gerbv/gerbv/gerbv-2.6.0/gerbv-2.6.0.tar.gz'
  sha1 'c9f5e8cddbc0b685805de42f81b1ba37dcbe1989'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'cairo'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-update-desktop-database"
    system "make install"
  end
end
