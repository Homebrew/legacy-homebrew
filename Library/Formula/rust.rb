require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'http://static.rust-lang.org/dist/rust-0.10.tar.gz'
  sha1 '20460730047ca6694eeb780d990f566572c32c43'

  head 'https://github.com/mozilla/rust.git'

  bottle do
    sha1 "b5b11a57f873c8fd3a794ede207839dcb0bfbe4b" => :mavericks
    sha1 "ca4d44441ef88c71cd98852c36d15d89e95d9fb7" => :mountain_lion
    sha1 "507705ef8749dd3cfae781f016e18bfcc09d8947" => :lion
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
