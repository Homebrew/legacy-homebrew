require 'formula'

class Asn1c < Formula
  homepage 'http://lionet.info/asn1c/blog/'
  url 'http://lionet.info/soft/asn1c-0.9.21.tar.gz'
  sha1 '22b8cbc73eab870ec2cab51997b3b0d422813624'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
