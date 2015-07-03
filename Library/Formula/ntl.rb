class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.2.0.tar.gz"
  sha256 "2bca70534b133904dd814a1d2a111f787a7506fa6f08f2e7f3fc9288b3bfd101"

  depends_on "gmp" => :optional

  bottle do
    cellar :any
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
