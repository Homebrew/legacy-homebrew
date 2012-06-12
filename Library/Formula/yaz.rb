require 'formula'

class Yaz < Formula
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-4.2.28.tar.gz'
  homepage 'http://www.indexdata.com/yaz'
  md5 '6c75d0448b729a013706748c7a8c3f7f'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml2"
    system "make install"
  end
end
