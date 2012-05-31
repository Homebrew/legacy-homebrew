require 'formula'

class Aespipe < Formula
  url 'http://loop-aes.sourceforge.net/aespipe/aespipe-v2.4c.tar.bz2'
  homepage 'http://loop-aes.sourceforge.net/'
  md5 '97b1f481721ea5d65018ddae1143bac5'
  version '2.4'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
