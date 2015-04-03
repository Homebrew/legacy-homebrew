require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rustc-1.0.0-beta-src.tar.gz'
  version "1.0.0-beta"
  sha256 '94248e30487723ac6f6c34a0db5a21085c0b1338e6a32bd12b159e1d2cd80451'

  head 'https://github.com/rust-lang/rust.git'

  bottle do
    sha256 "902e385b537dc813e34e6d10c5ed699eddf1746e9388a1110a9c26b20a873941" => :yosemite
    sha256 "4879fccbd594c57799938b33a4ba9ab9d5be2a6da9c2040f8165e2a0e8f146a9" => :mavericks
    sha256 "f98b6e8b49bc04d013dbf9864ee19664f0ab8eaab30e5d15aaa11b57213994e0" => :mountain_lion
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
