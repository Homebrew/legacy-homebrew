require 'formula'

class Libupnp < Formula
  homepage 'http://pupnp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.18/libupnp-1.6.18.tar.bz2'
  sha1 '7dc7bd2fa74a0f9c65b5fcc4c65b8faa6cf02007'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
