require 'formula'

class Cowpatty < Formula
  url 'http://www.willhackforsushi.com/code/cowpatty/4.3/cowpatty-4.3.tgz'
  homepage 'http://www.willhackforsushi.com/Cowpatty.html'
  md5 'DECCAC0763A05EF7014107D347BF9190'

  def install
    inreplace "Makefile", "/usr/local/", "#{prefix}/"
    system "make install"
  end
end
