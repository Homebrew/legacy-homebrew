require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rustc-1.0.0-beta-src.tar.gz'
  version "1.0.0-beta"
  sha256 '94248e30487723ac6f6c34a0db5a21085c0b1338e6a32bd12b159e1d2cd80451'

  head 'https://github.com/rust-lang/rust.git'

  bottle do
    revision 1
    sha256 "30c575c4b5f6580b9fa623b4cd49b7560290da7e0271650767e3d7f87099e6d4" => :yosemite
    sha256 "b86ff5452e4cce0cb93b601aec283cd47e06bd8336dbc3eece1e94f634c7e7ac" => :mavericks
    sha256 "5194f3ae7512d842ac8085628c31b1c36ceae0fb15382f3a1982bc9e80609ae3" => :mountain_lion
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
