require 'formula'

class Asciidoc < Formula
  homepage 'http://www.methods.co.nz/asciidoc'
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.8/asciidoc-8.6.8.tar.gz'
  sha1 '2fd88f6ca9d2a5e09045fb300f4a908fe6eeb092'

  head 'https://code.google.com/p/asciidoc/', :using => :hg

  depends_on :autoconf if build.head?
  depends_on 'docbook'

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"

    # otherwise OS X's xmllint bails out
    inreplace 'Makefile', '-f manpage', '-f manpage -L'
    system "make install"
  end
end
