require 'formula'

class Libaacs < Formula
  homepage 'http://www.videolan.org/developers/libaacs.html'
  url 'ftp://ftp.videolan.org/pub/videolan/libaacs/0.5.0/libaacs-0.5.0.tar.bz2'
  sha1 'f46f97e4c25ab6a43d59471a3a80d2aa8b0cb8ca'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'libgcrypt'

  def install
    inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    system './bootstrap'
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-extra-warnings"
    system "make install"
  end
end
