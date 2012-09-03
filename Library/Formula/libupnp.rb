require 'formula'

# Versions newer than 1.6.6 cause problems compiling ushare
# If you update this formula, please "brew install -v ushare"

class Libupnp < Formula
  url 'http://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.6/libupnp-1.6.6.tar.bz2'
  homepage 'http://pupnp.sourceforge.net/'
  sha1 '24c2c349cb52ed3d62121fbdae205c8d9dc0f5fa'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
