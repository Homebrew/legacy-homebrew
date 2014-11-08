require 'formula'

class Asn1c < Formula
  homepage 'http://lionet.info/asn1c/blog/'
  url 'http://lionet.info/soft/asn1c-0.9.24.tar.gz'
  sha1 'b12a78d5e0723c01fb9bf3d916be88824b68e6ee'

  bottle do
    revision 1
    sha1 "3c2a60011a528b5ab8a3d690bad1dc8d7055671e" => :yosemite
    sha1 "390a9550e70ead04dd2a212bd8239a2942250291" => :mavericks
    sha1 "2930ed406e3bc13347486e851423423d3a928c0e" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
