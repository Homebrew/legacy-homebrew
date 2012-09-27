require 'formula'

class Rpg < Formula
  url 'https://github.com/downloads/rtomayko/rpg/rpg-0.3.0.tar.gz'
  head 'https://github.com/rtomayko/rpg.git'
  homepage 'https://github.com/rtomayko/rpg'
  sha1 'acad232da1a560bdc0788bcfa203afcc58f0d7dc'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
