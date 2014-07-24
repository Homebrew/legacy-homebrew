require "formula"

class Xmount < Formula
  homepage "https://www.pinguin.lu/index.php"
  url "http://files.pinguin.lu/xmount-0.6.0.tar.gz"
  sha1 "4e584f5d288a7a6fe49b7bc3e45135b306c5bb82"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "osxfuse"
  depends_on "libewf"

  def install
    system "aclocal -I #{HOMEBREW_PREFIX}/share/aclocal"
    system "autoconf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
