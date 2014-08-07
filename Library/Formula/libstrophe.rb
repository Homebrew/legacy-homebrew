require "formula"

class Libstrophe < Formula
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.8.5.tar.gz"
  sha1 "11f80abb8e578c5bc446ff94603e7e0f560547f7"

  head do
    url "https://github.com/strophe/libstrophe.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "expat" => :recommended
  depends_on "check"

  def install
    ENV.deparallelize

    system "./bootstrap.sh"
    system "./configure",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "ld -dylib -lstrophe"
  end
end
