require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'http://static.rust-lang.org/dist/rust-0.6.tar.gz'
  sha256 'e11cb529a1e20f27d99033181a9e0e131817136b46d2742f0fa1afa1210053e5'

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
    system "#{bin}/cargo"
  end
end
