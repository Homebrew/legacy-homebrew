require 'formula'

class Adns < Formula
  homepage 'http://www.chiark.greenend.org.uk/~ian/adns/'
  url 'http://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.4.tar.gz'
  sha1 '87283c3bcd09ceb2e605e91abedfb537a18f1884'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-dynamic"
    system "make"
    system "make install"
  end
end
