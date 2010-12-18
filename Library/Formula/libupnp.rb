require 'formula'

class Libupnp < Formula
  url 'http://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.9/libupnp-1.6.9.tar.bz2'
  homepage 'http://pupnp.sourceforge.net/'
  md5 '111369142b9fc26081e8c4c7cd7f01c3'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
