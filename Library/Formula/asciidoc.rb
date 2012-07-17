require 'formula'

class Asciidoc < Formula
  homepage 'http://www.methods.co.nz/asciidoc'
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.7/asciidoc-8.6.7.tar.gz'
  sha1 '5fc55496b2a23e2cc1dcc1f6b1f75dd06fcdefa1'

  head 'https://code.google.com/p/asciidoc/', :using => :hg

  depends_on :autoconf if ARGV.build_head?
  depends_on 'docbook'

  def install
    system "autoconf" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}"

    # otherwise OS X's xmllint bails out
    inreplace 'Makefile', '-f manpage', '-f manpage -L'
    system "make install"
  end
end
