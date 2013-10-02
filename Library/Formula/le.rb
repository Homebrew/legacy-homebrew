require 'formula'

class Le < Formula
  homepage 'http://freecode.com/projects/leeditor'
  # url 'http://ftp.yar.ru/pub/source/le/le-1.14.9.tar.xz'
  # upstream not responding, source from debian
  url 'http://ftp.de.debian.org/debian/pool/main/l/le/le_1.14.9.orig.tar.gz'
  sha1 'ce85cbefb30cf1f5a7e8349dbb24ffa0f65b1fd7'

  def install
    ENV.j1
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
