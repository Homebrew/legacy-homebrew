require "formula"

class Cmockery2 < Formula
  desc "Reviving cmockery unit test framework from Google"
  homepage "https://github.com/lpabon/cmockery2"
  head "https://github.com/lpabon/cmockery2.git"
  url "https://github.com/lpabon/cmockery2/archive/v1.3.8.tar.gz"
  sha1 "5b5633c9f32b40451b2b94fa47495029f9fad919"

  bottle do
    cellar :any
    sha1 "b39492f8fe96daa1008922e4800e3e35b0393103" => :mavericks
    sha1 "d1925c9d80e45ba7250320ce4786bacd67194fff" => :mountain_lion
    sha1 "053629d4bb3fc0fe78184c5736e9b0fae64bdcd8" => :lion
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
