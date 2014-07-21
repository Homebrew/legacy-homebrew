require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'http://static.rust-lang.org/dist/rust-0.11.0.tar.gz'
  sha1 'f849e16e03b474143c575503ae82da7577a2170f'

  head 'https://github.com/mozilla/rust.git'

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
