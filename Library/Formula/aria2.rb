require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.16.3/aria2-1.16.3.tar.bz2'
  sha1 'b167ebe325d05a5acd37dcc59300c4f46bfdd42d'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls'

  # Leopard's libxml2 is too old.
  depends_on 'libxml2' if MacOS.version == :leopard

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
