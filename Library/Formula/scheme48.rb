class Scheme48 < Formula
  desc "Scheme byte-code interpreter"
  homepage "http://www.s48.org/"
  url "http://s48.org/1.9.2/scheme48-1.9.2.tgz"
  sha256 "9c4921a90e95daee067cd2e9cc0ffe09e118f4da01c0c0198e577c4f47759df4"

  bottle do
    sha1 "c2d1d64385b004856a2bf1e1683f49ba339c8046" => :mavericks
    sha1 "75692a9d2fdb41ffb11f05c1be298eb33143724b" => :mountain_lion
    sha1 "061274969680e03b26a5c2c44719a41fa417ff74" => :lion
  end

  conflicts_with "gambit-scheme", :because => "both install `scheme-r5rs` binaries"
  conflicts_with "scsh", :because => "both install include/scheme48.h"

  def install
    ENV.O0 if ENV.compiler == :clang
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-gc=bibop"
    system "make"
    system "make", "install"
  end
end
