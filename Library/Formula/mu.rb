require 'formula'

class Mu < Formula
  url 'http://mu0.googlecode.com/files/mu-0.9.6.tar.gz'
  homepage 'http://www.djcbsoftware.nl/code/mu/'
  md5 '72fdf907f2b7922a54c8d14bc4b06ccf'

  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gmime'
  depends_on 'xapian'

  def install
    system  "./configure", "--prefix=#{prefix}",
      "--disable-dependency-tracking", "--with-gui=none"
    system "make"
    system "make install"
  end
end
