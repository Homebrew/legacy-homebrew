require "formula"

class Libsodium < Formula
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.1/libsodium-1.0.1.tar.gz"
  sha256 "c3090887a4ef9e2d63af1c1e77f5d5a0656fadb5105ebb9fb66a302210cb3af5"

  bottle do
    cellar :any
    sha1 "1432ec12353213ebfbb8e31e839eea9cedba7d2d" => :yosemite
    sha1 "8b66ef0a978e3aac54036f447053585b809a6e40" => :mavericks
    sha1 "9b6cc830b3b36e20ac8dcfc076e450ba1505c46f" => :mountain_lion
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end
end
