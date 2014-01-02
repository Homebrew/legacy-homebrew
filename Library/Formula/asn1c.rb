require 'formula'

class Asn1c < Formula
  homepage 'http://lionet.info/asn1c/blog/'
  url 'http://lionet.info/soft/asn1c-0.9.24.tar.gz'
  sha1 'b12a78d5e0723c01fb9bf3d916be88824b68e6ee'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
