require 'formula'

class Afflib <Formula
  url 'http://afflib.org/downloads/afflib-3.6.3.tar.gz'
  homepage 'http://afflib.org'
  md5 'b81b5b126cb9c45137bf1ad5d09c99b8'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
