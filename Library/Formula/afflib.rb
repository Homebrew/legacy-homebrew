require 'formula'

class Afflib < Formula
  homepage 'http://afflib.org'
  url 'https://github.com/downloads/simsong/AFFLIBv3/afflib-3.7.1.tar.gz'
  sha1 'fb35a2383a48b49f68e25ca97d67ee02342826ba'

  depends_on 'expat' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
