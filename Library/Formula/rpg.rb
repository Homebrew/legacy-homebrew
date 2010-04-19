require 'formula'

class Rpg <Formula
  url 'http://github.com/rtomayko/rpg/tarball/0.1.0'
  homepage 'http://github.com/rtomayko/rpg'
  md5 'b5bd86db52665a2dbbefe69fad005722'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
