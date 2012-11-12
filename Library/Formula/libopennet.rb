require 'formula'

class Libopennet < Formula
  url 'http://www.rkeene.org/files/oss/libopennet/libopennet-0.9.9.tar.gz'
  homepage 'http://www.rkeene.org/oss/libopennet'
  sha1 'd15c698498401ec6036646eaf19914117d6f5c56'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
