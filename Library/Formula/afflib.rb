require 'formula'

class Afflib < Formula
  url 'http://afflib.org/downloads/afflib-3.6.15.tar.gz'
  homepage 'http://afflib.org'
  md5 'ca04f2d1bda64e0cedaf4af7a9bf4298'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
