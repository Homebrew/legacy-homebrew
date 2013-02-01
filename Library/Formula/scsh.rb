require 'formula'

class Scsh < Formula
  homepage 'http://www.scsh.net/'
  url 'http://ftp.scsh.net/pub/scsh/0.6/scsh-0.6.7.tar.gz'
  sha1 'a1eaf0d0593e14914824898a0c3ec166429affd7'

  def install
    # will not build 64-bit
    ENV.m32
    # build system is not parallel-safe
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make install"
  end
end
