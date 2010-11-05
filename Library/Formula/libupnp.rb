require 'formula'

class Libupnp < Formula
  url 'http://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.8/libupnp-1.6.8.tar.bz2'
  homepage 'http://pupnp.sourceforge.net/'
  md5 '7e162895b9d0f9efcccd07973012cdff'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
