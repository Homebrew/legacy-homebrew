require 'formula'

class Groonga < Formula
  url 'http://packages.groonga.org/source/groonga/groonga-1.2.7.tar.gz'
  homepage 'http://groonga.org/'
  md5 'ef83d94b8e602507b068f3f6d5cf8e92'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
