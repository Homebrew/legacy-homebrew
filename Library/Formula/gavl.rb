require 'formula'

class Gavl < Formula
  url 'http://sourceforge.net/projects/gmerlin/files/gavl/1.2.0/gavl-1.2.0.tar.gz'
  homepage 'http://gmerlin.sourceforge.net/'
  md5 'f7dd25d3ef26a8d22f947e9383d251e7'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--without-doxygen"
    system "make install"
  end
end
