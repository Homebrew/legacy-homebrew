require 'formula'

class Afflib <Formula
  url 'http://afflib.org/downloads/afflib-3.6.6.tar.gz'
  homepage 'http://afflib.org'
  md5 'b7ff4d2945882018eb1536cad182ad01'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
