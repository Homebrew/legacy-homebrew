require 'formula'

class ChibiScheme < Formula
  homepage 'http://code.google.com/p/chibi-scheme/'
  url 'http://chibi-scheme.googlecode.com/files/chibi-scheme-0.6.1.tgz'
  sha1 '8cf1d35aaceaebc1b305e4ee3b872f3ce014106a'
  head 'https://code.google.com/p/chibi-scheme/', :using => :hg

  def install
    # "make" and "make install" must be done separately
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
