require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-2.0.3.tar.gz'
  homepage 'http://groonga.org/'
  sha1 'a9dffb17bf722f12c45c43d56243d8c72a31f8c8'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
