require 'formula'

class ChibiScheme < Formula
  homepage 'http://code.google.com/p/chibi-scheme/'
  url 'http://chibi-scheme.googlecode.com/files/chibi-scheme-0.5.3.tgz'
  sha1 '3ebaa7cc8671a38deacd4873f4f800bbebdb341e'
  head 'https://code.google.com/p/chibi-scheme/', :using => :hg

  def install
    # "make" and "make install" must be done separately
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
