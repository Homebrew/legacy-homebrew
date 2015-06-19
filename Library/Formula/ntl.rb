require "formula"

class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-6.2.1.tar.gz"
  sha1 "3b9ab3bedb0b2e9b5ee322d60745be5caf1c743f"

  depends_on "gmp" => :optional

  bottle do
    cellar :any
    revision 1
    sha256 "12dc24f6cd3807d3a135574b36d64e16ac3944c05eb9ca7757dbee0ce1226cd1" => :yosemite
    sha256 "0b80767d99050fa064701770ab15ec316c1223dc25616d6639113832eb86eab1" => :mavericks
    sha256 "344f78d64fb0ada8131e37f40827dff54842c58e271d2284da247b1ee1d509bf" => :mountain_lion
  end

  def install
    args = ["PREFIX=#{prefix}"]
    args << "NTL_GMP_LIP=on" if build.with? "gmp"
    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end
end
