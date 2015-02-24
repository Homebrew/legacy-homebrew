require 'formula'

class Rust < Formula
  homepage 'http://www.rust-lang.org/'
  url 'https://static.rust-lang.org/dist/rustc-1.0.0-alpha-src.tar.gz'
  version "1.0.0-alpha"
  sha256 '3a2285726e839fc57ad49ed8907a50bab2d29d8f898e2d5a02f620a0477fc25c'

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
    system "#{bin}/rustc"
    system "#{bin}/rustdoc", "-h"
  end
end
