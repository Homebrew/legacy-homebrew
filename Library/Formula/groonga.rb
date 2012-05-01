require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-2.0.2.tar.gz'
  homepage 'http://groonga.org/'
  md5 '8791e4f0b08c8065d6836b2fb18a295a'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
