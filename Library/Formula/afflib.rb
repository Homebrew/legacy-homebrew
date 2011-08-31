require 'formula'

class Afflib < Formula
  url 'http://afflib.org/downloads/afflib-3.6.12.tar.gz'
  homepage 'http://afflib.org'
  md5 '8d0026e71ecb86089ced39204a103828'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
