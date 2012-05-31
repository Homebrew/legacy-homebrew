require 'formula'

class Utimer < Formula
  url 'http://utimer.codealpha.net/dl.php?file=utimer-0.4.tar.gz'
  homepage 'http://utimer.codealpha.net/utimer/'
  md5 '5fc82bcea449bdc3527a6833a1196641'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'XML::Parser' => :perl

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
