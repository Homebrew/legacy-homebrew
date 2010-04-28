require 'formula'

class Rpg <Formula
  url 'http://github.com/downloads/rtomayko/rpg/rpg-0.2.0.tar.gz'
  homepage 'http://github.com/rtomayko/rpg'
  md5 '7bf07b59a436b8f2677d660ed6f0afca'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
