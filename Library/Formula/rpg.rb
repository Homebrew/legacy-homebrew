require 'formula'

class Rpg <Formula
  url 'https://github.com/downloads/rtomayko/rpg/rpg-0.3.0.tar.gz'
  homepage 'https://github.com/rtomayko/rpg'
  md5 '5e03c55e24ba697bc5bb92ec4c69750c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
