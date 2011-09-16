require 'formula'

class Mu < Formula
  homepage 'http://www.djcbsoftware.nl/code/mu/'
  unless ARGV.flag? '--devel'
  url 'http://mu0.googlecode.com/files/mu-0.9.6.tar.gz'
  md5 '811e896894f789ef1b87316d4322b412'
  else
  url 'http://mu0.googlecode.com/files/mu-0.9.7-pre.tar.gz'
  md5 '72fdf907f2b7922a54c8d14bc4b06ccf'
  end

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
