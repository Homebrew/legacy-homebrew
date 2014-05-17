require 'formula'

class Cowpatty < Formula
  homepage 'http://www.willhackforsushi.com/Cowpatty.html'
  url 'http://www.willhackforsushi.com/code/cowpatty/4.3/cowpatty-4.3.tgz'
  sha1 '8b7cb2015d0534031827f2f06135bf5cf5929d35'

  def install
    ENV.j1
    inreplace "Makefile", "/usr/local/", "#{prefix}/"
    system "make install"
  end
end
