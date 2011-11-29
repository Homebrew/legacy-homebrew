require 'formula'

class ChibiScheme < Formula
  url 'http://chibi-scheme.googlecode.com/files/chibi-scheme-0.5.1.tgz'
  homepage 'http://code.google.com/p/chibi-scheme/'
  md5 'c29c4721cd31d6bcafd061dfcf622f46'
  head 'https://code.google.com/p/chibi-scheme/', :using => :hg

  def install
    # "make" and "make install" must be done separately
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end
