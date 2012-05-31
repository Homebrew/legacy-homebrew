require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.15.1/aria2-1.15.1.tar.bz2'
  sha1 '67b70d3492b0edb3af314a253540b921e1bc0c4e'

  depends_on 'pkg-config' => :build

  # Leopard's libxml2 is too old.
  depends_on 'libxml2' if MacOS.leopard?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
