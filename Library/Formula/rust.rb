require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'http://static.rust-lang.org/dist/rust-0.7.tar.gz'
  sha256 '0b88b8a4489382e0a69214eaab88e2e7c316ec33c164af0d3b53630b17590df0'

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
    system "#{bin}/rustdoc"
    system "#{bin}/rustpkg"
  end
end
