require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rust-0.12.0.tar.gz'
  sha256 '883e66b24d90d9957c5c538469fcde6f0668e5fb6448beecfc60884060e769b7'

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
