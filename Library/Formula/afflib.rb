require 'formula'

class Afflib < Formula
  url 'http://afflib.org/downloads/afflib-3.6.9.tar.gz'
  homepage 'http://afflib.org'
  md5 'c946359e5f410a76bc4aa0ea2eabd5a1'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
