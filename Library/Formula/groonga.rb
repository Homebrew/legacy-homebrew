require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-2.0.1.tar.gz'
  homepage 'http://groonga.org/'
  md5 '806daed3e0e5bb12d591dcf326e4ccd5'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
