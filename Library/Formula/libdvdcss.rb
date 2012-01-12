require 'formula'

class Libdvdcss < Formula
  url 'http://download.videolan.org/pub/libdvdcss/1.2.11/libdvdcss-1.2.11.tar.bz2'
  md5 'd25d906c3f9007ccd91b1efb909f93e7'
  head 'svn://svn.videolan.org/libdvdcss/trunk'
  homepage 'http://www.videolan.org/developers/libdvdcss.html'

  def install
    system "./bootstrap" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
