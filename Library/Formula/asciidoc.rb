require 'formula'

class Asciidoc < Formula
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.7/asciidoc-8.6.7.tar.gz'
  md5 'edcf05b28ce21a4d27b1cd3028930021'
  head 'https://code.google.com/p/asciidoc/', :using => :hg
  homepage 'http://www.methods.co.nz/asciidoc'

  depends_on 'docbook'

  def install
    system "autoconf" if ARGV.build_head? and not File.exists? "./configure"
    system "./configure", "--prefix=#{prefix}"

    # otherwise OS X's xmllint bails out
    inreplace 'Makefile', '-f manpage', '-f manpage -L'
    system "make install"
  end
end
