require 'formula'

class Afflib < Formula
  url 'http://afflib.org/downloads/afflib-3.6.16.tar.gz'
  homepage 'http://afflib.org'
  md5 '4a4a916c9097770e6be277901a093cc4'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
