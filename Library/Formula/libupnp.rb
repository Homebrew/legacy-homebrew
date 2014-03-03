require 'formula'

class Libupnp < Formula
  homepage 'http://pupnp.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.19/libupnp-1.6.19.tar.bz2'
  sha1 'ee9e16ff42808521b62b7fc664fc9cba479ede88'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
