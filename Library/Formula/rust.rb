require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'http://static.rust-lang.org/dist/rust-0.10.tar.gz'
  sha1 '20460730047ca6694eeb780d990f566572c32c43'

  head 'https://github.com/mozilla/rust.git'

  bottle do
    sha1 'faecc6797465be3297554bf18c4b0ff73d27bfb1' => :mavericks
    sha1 '4546c45d79531e0797af6e7bd9c6b2aaceb8b1e4' => :mountain_lion
    sha1 '924740d0e449bab18e7f06f263ee2f1ececee5f4' => :lion
  end

  fails_with :clang do
    build 318
    cause "cannot initialize a parameter of type 'volatile long long *' with an rvalue of type 'int *'"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--disable-rpath" if build.head?
    args << "--enable-clang" if ENV.compiler == :clang
    system "./configure", *args
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/rustc"
    system "#{bin}/rustdoc", "-h"
  end
end
