require 'formula'

class Libupnp < Formula
  homepage 'http://pupnp.sourceforge.net/'
  url 'http://sourceforge.net/projects/pupnp/files/pupnp/libUPnP%201.6.17/libupnp-1.6.17.tar.bz2'
  sha1 '179e0c1337915d45ea8c04c1fa86257c9dfc5924'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ipv6"
    system "make install"
  end
end
