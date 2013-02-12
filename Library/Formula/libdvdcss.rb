require 'formula'

class Libdvdcss < Formula
  homepage 'http://www.videolan.org/developers/libdvdcss.html'
  url 'http://download.videolan.org/pub/libdvdcss/1.2.12/libdvdcss-1.2.12.tar.bz2'
  sha1 'f0977374f12fadbbeb45e1ff493adc259247bb09'

  head 'svn://svn.videolan.org/libdvdcss/trunk'

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
