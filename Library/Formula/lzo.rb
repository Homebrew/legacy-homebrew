require "formula"

class Lzo < Formula
  homepage "http://www.oberhumer.com/opensource/lzo/"
  url "http://www.oberhumer.com/opensource/lzo/download/lzo-2.08.tar.gz"
  sha256 "ac1b3e4dee46febe9fd28737eb7f5692d3232ef1a01da10444394c3d47536614"

  bottle do
    cellar :any
    sha1 "c5faa08e3758afbeba605a31bb4b4c0c7b1cd25c" => :mavericks
    sha1 "019f27adfb514ef4dfdd8b80337e0f3f1485fa0c" => :mountain_lion
    sha1 "8dd58a1646f3473722302b831022ba7a2630e0fb" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
