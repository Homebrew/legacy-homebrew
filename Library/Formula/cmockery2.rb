class Cmockery2 < Formula
  desc "Reviving cmockery unit test framework from Google"
  homepage "https://github.com/lpabon/cmockery2"
  url "https://github.com/lpabon/cmockery2/archive/v1.3.9.tar.gz"
  sha256 "c38054768712351102024afdff037143b4392e1e313bdabb9380cab554f9dbf2"
  head "https://github.com/lpabon/cmockery2.git"

  bottle do
    cellar :any
    sha256 "ea94ba8420bd5bc01412b52ce9c03b392b933f279d1bce7a8ff8f7502bc83f88" => :yosemite
    sha256 "ce0cc1a3151655d4bb970ca92c87c5ebb5ed660c3c445e763edc4b835ca7e9a6" => :mavericks
    sha256 "c7fbc1a75a2c4c517cea269fdd9567c6ebd74d6917624e4d084932edf13bb77b" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    (share+"example").install "src/example/calculator.c"
  end

  test do
    system ENV.cc, share+"example/calculator.c", "-lcmockery", "-o", "calculator"
    system "./calculator"
  end
end
