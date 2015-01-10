require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rustc-1.0.0-alpha-src.tar.gz'
  version "1.0.0-alpha"
  sha256 '3a2285726e839fc57ad49ed8907a50bab2d29d8f898e2d5a02f620a0477fc25c'

  head 'https://github.com/rust-lang/rust.git'

  bottle do
    sha1 "8cc3fabfd93f5554e022d9f41f6950c27d427b44" => :mavericks
    sha1 "0940a33152968c39b9f6d5f91b5405b92e16ebe7" => :mountain_lion
    sha1 "c626fbcafc7b21533dd9df9a46cc124fa34a3321" => :lion
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
