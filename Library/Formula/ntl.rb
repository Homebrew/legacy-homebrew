require 'formula'

class Ntl < Formula
  url 'http://www.shoup.net/ntl/ntl-5.5.2.tar.gz'
  homepage 'http://www.shoup.net/ntl'
  md5 '2e0afa1fa3b325e562ce89da57cba983'

  def install
    Dir.chdir "src"
    system "./configure", "PREFIX=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
