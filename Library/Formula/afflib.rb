require 'formula'

class Afflib < Formula
  url 'http://afflib.org/downloads/afflib-3.6.8.tar.gz'
  homepage 'http://afflib.org'
  md5 'c170ea4e3bcd3c0e286b4d5d904bc367'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
