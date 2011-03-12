require 'formula'

class Groonga <Formula
  url 'http://groonga.org/files/groonga/groonga-1.0.6.tar.gz'
  homepage 'http://groonga.org/'
  md5 'a278e72801a68acf374cbc309d73ba34'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
