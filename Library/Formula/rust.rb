require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'http://dl.rust-lang.org/dist/rust-0.5.tar.gz'
  sha256 'd326d22707f0562d669c11efbc33ae812ddbf76ab78f07087fc5beb095a8928a'

  fails_with :clang do
    build 318
    cause "cannot initialize a parameter of type 'volatile long long *' with an rvalue of type 'int *'"
  end

  # Fix repl showstopper bug; can be removed for 0.6.
  def patches
    [ "https://github.com/gifnksm/rust/commit/9bf87bbf66227c132283ae59720f919601de9a56.patch",
    "https://github.com/gifnksm/rust/commit/3ee1d3ebb81de199fc630a86933ac18c0a869482.patch" ]
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
