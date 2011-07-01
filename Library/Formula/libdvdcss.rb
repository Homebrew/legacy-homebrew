require 'formula'

class Libdvdcss < Formula
  url 'http://download.videolan.org/pub/libdvdcss/1.2.9/libdvdcss-1.2.9.tar.bz2'
  md5 '553383d898826c285afb2ee453b07868'
  homepage 'http://www.videolan.org/developers/libdvdcss.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
