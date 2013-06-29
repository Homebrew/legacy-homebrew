require 'formula'

class Libbinio < Formula
  homepage 'http://libbinio.sf.net'
  url 'http://downloads.sourceforge.net/project/libbinio/libbinio/1.4/libbinio-1.4.tar.bz2'
  sha1 '47db5f7448245f38b9d26c8b11f53a07b6f6da73'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
