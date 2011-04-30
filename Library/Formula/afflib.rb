require 'formula'

class Afflib < Formula
  url 'http://afflib.org/downloads/afflib-3.6.10.tar.gz'
  homepage 'http://afflib.org'
  md5 '36ff2ab7708f89bf736dfb8b197ce93c'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
