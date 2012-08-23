require 'formula'

class Libdvdcss < Formula
  homepage 'http://www.videolan.org/developers/libdvdcss.html'
  url 'http://download.videolan.org/pub/libdvdcss/1.2.11/libdvdcss-1.2.11.tar.bz2'
  sha1 '55d75d603071aa4bbcd7a7dcfa63c52dd0e8a104'
  head 'svn://svn.videolan.org/libdvdcss/trunk'

  def install
    system "./bootstrap" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
