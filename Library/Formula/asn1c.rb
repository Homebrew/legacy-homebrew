require 'formula'

class Asn1c < Formula
  homepage 'http://lionet.info/asn1c/blog/'
  url 'http://lionet.info/soft/asn1c-0.9.24.tar.gz'
  sha1 'b12a78d5e0723c01fb9bf3d916be88824b68e6ee'

  bottle do
    sha1 "7fb4a515ba1d88e98fc17564389b94b49af64d4b" => :yosemite
    sha1 "8795d4588c8318d4a7c1ba4077893a20c8e6643a" => :mavericks
    sha1 "bf0435b8c6844c8ea2909129d7d3ca95386c8172" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
