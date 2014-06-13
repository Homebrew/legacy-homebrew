require "formula"

class Fswatch < Formula
  homepage "https://github.com/alandipert/fswatch"
  url "https://github.com/alandipert/fswatch/archive/1.3.6.tar.gz"
  sha1 "e3dc16f2b181452f864a7cb4718d1aa0f8a0ee2f"

  bottle do
    sha1 "915a9948cf26cbf7f12225de136c25bacc2d030a" => :mavericks
    sha1 "6900820cc5aac8bce488c743139a6a8bdb41b2ae" => :mountain_lion
    sha1 "0764779ee5ce0483a3c781c64892c9b02938e14e" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
