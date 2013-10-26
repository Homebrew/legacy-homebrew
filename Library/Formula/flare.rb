require 'formula'

class Flare < Formula
  homepage 'https://github.com/gree/flare/wiki'
  url 'http://gree.github.io/flare/files/flare-1.0.17.1.zip'
  sha1 '24a09e1d7686aa561dac4f3873e114ee15a7706d'

  head 'https://github.com/fujimoto/flare.git'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'tokyo-cabinet'
  depends_on 'boost'

  def install
    # Compatibility with Automake 1.13 and newer.
    inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    system "autoreconf -vfi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
