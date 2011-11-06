require 'formula'

class Libdvdcss < Formula
  url 'http://download.videolan.org/pub/libdvdcss/1.2.10/libdvdcss-1.2.10.tar.bz2'
  md5 'ebd5370b79ac5a83e5c61b24a214cf74'
  head 'svn://svn.videolan.org/libdvdcss/trunk'
  homepage 'http://www.videolan.org/developers/libdvdcss.html'

  def install
    system "./bootstrap" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
