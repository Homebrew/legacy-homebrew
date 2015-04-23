require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rustc-1.0.0-beta.2-src.tar.gz'
  version "1.0.0-beta.2"
  sha256 '969f20bfec588456af8ab81c9b00ef46df075bf9ac9955e42a87b1f39cb99771'

  head 'https://github.com/rust-lang/rust.git'

  bottle do
    sha256 "b2daf887ed5bd0d52dd5b96d3ddab38901d63c1408534660138bbf05bac922c8" => :yosemite
    sha256 "7c49753fb3e7f80eedea6122652d307f71fe9426a124abbd0936ae91871006e9" => :mavericks
    sha256 "96800a3840fd0e929216d22ff768c839ed7fb3046c62ca67b8793af6e72e9fc3" => :mountain_lion
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--disable-rpath" if build.head?
    args << "--enable-clang" if ENV.compiler == :clang
    args << "--release-channel=beta" unless build.head?
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
