require 'formula'

class ChibiScheme < Formula
  url 'http://chibi-scheme.googlecode.com/files/chibi-scheme-0.5.tgz'
  homepage 'http://code.google.com/p/chibi-scheme/'
  md5 'b7a14bf7827b43c83b56eaaa9254e5e3'

  def install
    system "make && make install PREFIX=#{prefix}"
  end
end