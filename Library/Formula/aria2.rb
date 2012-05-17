require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.15.0/aria2-1.15.0.tar.bz2'
  sha1 'b29e498a31fdcf890ba93749a221f6022784e003'

  depends_on 'pkg-config' => :build

  # Leopard's libxml2 is too old.
  depends_on 'libxml2' if MacOS.leopard?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
