require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rustc-1.0.0-beta.3-src.tar.gz'
  version "1.0.0-beta.3"
  sha256 'e751bc8a8ad236c8865697f866b2863e224af56b0194ddf9f3edd71f9ff6545f'

  head 'https://github.com/rust-lang/rust.git'

  bottle do
    sha256 "60450a633c8c5f42e208b647699fd872e594fd5475f460b0367bbbf02063a466" => :yosemite
    sha256 "1c265ffd3c678acd05b6525c2de6730881b540d1b8419f2b496cf244b46d88c2" => :mavericks
    sha256 "2385a4baa211953a94bb93f5ce6f5ca5d5826f3e1d7c0d12310e78c5571f3c89" => :mountain_lion
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
