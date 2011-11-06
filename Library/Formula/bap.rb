require 'formula'

class Bap < Formula
  head 'http://bap.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/bap/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    inreplace "scanner.l", "int yylineno", "//int yylineno"
    system "make"
    bin.install %w(bap aex prep)
    doc.install "TODO"
  end
end
