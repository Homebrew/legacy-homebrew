require 'formula'

class Rpg < Formula
  homepage 'https://github.com/rtomayko/rpg'
  url 'https://github.com/downloads/rtomayko/rpg/rpg-0.3.0.tar.gz'
  sha1 'acad232da1a560bdc0788bcfa203afcc58f0d7dc'

  head 'https://github.com/rtomayko/rpg.git'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
