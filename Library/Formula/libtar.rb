require 'formula'

class Libtar < Formula
  homepage 'http://www.feep.net/libtar/'
  url 'ftp://ftp.feep.net/pub/software/libtar/libtar-1.2.11.tar.gz'
  sha1 '9611f23024b0e89aad1cfea301122186b3c160f8'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
