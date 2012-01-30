require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-1.3.0.tar.gz'
  homepage 'http://groonga.org/'
  md5 'd8b3ada75185b59665131e4eee30d107'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
