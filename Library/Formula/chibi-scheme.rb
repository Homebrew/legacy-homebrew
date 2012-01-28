require 'formula'

class ChibiScheme < Formula
  url 'http://chibi-scheme.googlecode.com/files/chibi-scheme-0.5.3.tgz'
  homepage 'http://code.google.com/p/chibi-scheme/'
  md5 '26941ff819ee51056c700d94b7cb95c0'
  head 'https://code.google.com/p/chibi-scheme/', :using => :hg

  def install
    # "make" and "make install" must be done separately
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end
