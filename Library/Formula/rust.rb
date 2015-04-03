require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rustc-1.0.0-beta-src.tar.gz'
  version "1.0.0-beta"
  sha256 '94248e30487723ac6f6c34a0db5a21085c0b1338e6a32bd12b159e1d2cd80451'

  head 'https://github.com/rust-lang/rust.git'

  bottle do
    sha1 "c1a024f85c9af99d140762de3c87738b00ead44e" => :yosemite
    sha1 "325c8021a0c911e39eb536879698aa5e21e2ab05" => :mavericks
    sha1 "e0bbe731065a341f65722ed2e6f9e3861d8bb702" => :mountain_lion
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
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<-EOS.undent
    fn main() {
      println!("Hello World!");
    }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
  end
end
