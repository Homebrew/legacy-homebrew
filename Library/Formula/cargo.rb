require 'formula'

class Cargo < Formula
  homepage 'http://crates.io'
  url "https://static.rust-lang.org/cargo-dist/cargo-nightly-x86_64-apple-darwin.tar.gz"
  #sha1 ""

  head 'https://github.com/rust-lang/cargo.git'
  depends_on "cmake"
  depends_on "pkg-config"
  depends_on "rust"
  depends_on "openssl"

  def install
    args = ["--destdir=#{prefix}", "--prefix=/"]
    system "./install.sh", *args 
  end
  
  test do
    system "#{bin}/cargo"
  end
end
