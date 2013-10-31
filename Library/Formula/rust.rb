require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'http://static.rust-lang.org/dist/rust-0.8.tar.gz'
  sha256 '42f791ab1537357fe0f63d67ffe6bcb64ecf16b2bd3f1484ab589823f5914182'

  head 'https://github.com/mozilla/rust.git'

  fails_with :clang do
    build 318
    cause "cannot initialize a parameter of type 'volatile long long *' with an rvalue of type 'int *'"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-clang" if ENV.compiler == :clang
    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/rustc"
    system "#{bin}/rustdoc -h"
    system "#{bin}/rustpkg -v"
  end
end
