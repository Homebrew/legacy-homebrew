require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rustc-1.0.0-alpha.2-src.tar.gz'
  version "1.0.0-alpha.2"
  sha256 'a931b945e98f409df68fdff23e98b688024461c28901106896e73708381956c8'

  head 'https://github.com/rust-lang/rust.git'

  bottle do
    sha1 "5277e1c21e09bebde2c721be9b21680ba85d78bf" => :yosemite
    sha1 "b46ed4b2cc08432f45cb9f28b2e5ee66280787ff" => :mavericks
    sha1 "7d8e4945fffaf1844f166c7450d068e0860962b2" => :mountain_lion
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
