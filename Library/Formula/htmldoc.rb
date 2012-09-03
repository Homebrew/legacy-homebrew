require 'formula'

class Htmldoc < Formula
  url 'http://ftp.easysw.com/pub/htmldoc/1.8.27/htmldoc-1.8.27-source.tar.bz2'
  homepage 'http://www.htmldoc.org'
  sha1 '472908e0aafed1cedfbacd8ed3168734aebdec4b'

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
