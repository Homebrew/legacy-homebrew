require "formula"

class Lzo < Formula
  homepage "http://www.oberhumer.com/opensource/lzo/"
  url "http://www.oberhumer.com/opensource/lzo/download/lzo-2.08.tar.gz"
  sha256 "ac1b3e4dee46febe9fd28737eb7f5692d3232ef1a01da10444394c3d47536614"

  bottle do
    cellar :any
    sha1 "39b3bddecc7646bac80d1b12931148932b9ff6b1" => :mavericks
    sha1 "0a752df8103e1020b2d8d7fa9fa0a8ce59f9cddc" => :mountain_lion
    sha1 "d88d2c7a55df8acf9cdfe7b3438e04c07e284adc" => :lion
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
