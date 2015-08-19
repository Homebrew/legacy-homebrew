class Libopennet < Formula
  desc "open_net(), similar to open()"
  homepage "http://www.rkeene.org/oss/libopennet"
  url "http://www.rkeene.org/files/oss/libopennet/libopennet-0.9.9.tar.gz"
  sha256 "d1350abe17ac507ffb50d360c5bf8290e97c6843f569a1d740f9c1d369200096"

  bottle do
    cellar :any
    sha1 "63dac8f3ec1c97043aac3b46cf004bb5c70f688c" => :yosemite
    sha1 "36361dd6ba28e2ed7e9aa7b5f9274998d83697a0" => :mavericks
    sha1 "0f1653162c70f915023a63adc0f0e345d15d0a61" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
