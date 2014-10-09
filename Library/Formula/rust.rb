require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rust-0.12.0.tar.gz'
  sha256 '883e66b24d90d9957c5c538469fcde6f0668e5fb6448beecfc60884060e769b7'

  head 'https://github.com/rust-lang/rust.git'

  bottle do
    sha1 "80cb5b7ab75da8fdab98f56441a69a2a3e575595" => :mavericks
    sha1 "476b4a75e28c68fec195535ed2aaf8082af9597f" => :mountain_lion
    sha1 "e4246f7544502ac83c4485e82660ab5bcce96979" => :lion
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
    system "#{bin}/rustc"
    system "#{bin}/rustdoc", "-h"
  end
end
