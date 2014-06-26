require "formula"

class R3 < Formula
  homepage "https://github.com/c9s/r3"
  url "https://github.com/c9s/r3/archive/1.0.0.tar.gz"
  sha1 "2cc3b1bac5ce83d884cd77639407198ec3c08b84"

  head "https://github.com/c9s/r3.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check" => :build
  depends_on "pcre"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
