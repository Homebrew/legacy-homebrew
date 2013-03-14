require 'formula'

class Libpuzzle < Formula
  homepage 'http://libpuzzle.pureftpd.org/project/libpuzzle'
  url 'http://download.pureftpd.org/pub/pure-ftpd/misc/libpuzzle/releases/libpuzzle-0.11.tar.bz2'
  sha1 'a3352c67fd61eab33d5a03c214805b18723d719e'

  depends_on 'gd'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
