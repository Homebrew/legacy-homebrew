require 'formula'

class Groonga <Formula
  url 'http://groonga.org/files/groonga/groonga-0.7.4.tar.gz'
  homepage 'http://groonga.org/'
  md5 '6c3e2a922a45f76a7c766defce7385fa'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
