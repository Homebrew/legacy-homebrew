require 'formula'

class Asn1c < Formula
  url 'http://lionet.info/soft/asn1c-0.9.21.tar.gz'
  homepage 'http://lionet.info/asn1c/blog/'
  md5 '0d06f96d345530e66e44e7bfee2e0aed'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                           "--mandir=#{man}"
    system "make install"
  end
end
