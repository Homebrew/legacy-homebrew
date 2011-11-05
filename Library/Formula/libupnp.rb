require 'formula'

# Versions newer than 1.6.6 cause problems compiling ushare
# If you update this formula, please "brew install -v ushare"

class Libupnp < Formula
  url 'http://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.6/libupnp-1.6.6.tar.bz2'
  homepage 'http://pupnp.sourceforge.net/'
  md5 '8918dcf7428cd119d0c8275765ff2833'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
