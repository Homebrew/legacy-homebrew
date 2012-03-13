require 'formula'

class Scsh < Formula
  url 'http://ftp.scsh.net/pub/scsh/0.6/scsh-0.6.7.tar.gz'
  homepage 'http://www.scsh.net/'
  md5 '69c88ca86a8aaaf0f87d253b99d339b5'

  def install
    # will not build 64-bit
    ENV.m32
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make install"
  end
end
