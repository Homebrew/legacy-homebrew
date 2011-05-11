require 'formula'

class Afflib < Formula
  url 'http://afflib.org/downloads/afflib-3.6.11.tar.gz'
  homepage 'http://afflib.org'
  md5 'd2df61d11e249fc8be73fd7598650d61'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
