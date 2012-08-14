require 'formula'

class Cowpatty < Formula
  homepage 'http://www.willhackforsushi.com/Cowpatty.html'
  url 'http://www.willhackforsushi.com/code/cowpatty/4.3/cowpatty-4.3.tgz'
  md5 'deccac0763a05ef7014107d347bf9190'

  def install
    inreplace "Makefile", "/usr/local/", "#{prefix}/"
    system "make install"
  end
end
