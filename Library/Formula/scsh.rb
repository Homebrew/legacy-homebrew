require 'formula'

class Scsh < Formula
  url 'http://ftp.scsh.net/pub/scsh/0.6/scsh-0.6.7.tar.gz'
  homepage 'http://www.scsh.net/'
  md5 '69c88ca86a8aaaf0f87d253b99d339b5'

  def install
    # 4.2 segfaults in building phase
    ENV.gcc_4_0
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make install"
  end
end
