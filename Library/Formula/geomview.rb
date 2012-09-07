require 'formula'

class Geomview < Formula
  url 'http://sourceforge.net/projects/geomview/files/geomview/1.9.4/geomview-1.9.4.tar.gz'
  homepage 'http://www.geomview.org'
  sha1 'b5e04dfee5cef46655766c2456199905832cd45c'

  depends_on :x11
  depends_on 'lesstif'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
