require 'formula'

class Afflib <Formula
  url 'http://afflib.org/downloads/afflib-3.6.4.tar.gz'
  homepage 'http://afflib.org'
  md5 'bc03dcd98b8a1d04169b6261ce304458'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
