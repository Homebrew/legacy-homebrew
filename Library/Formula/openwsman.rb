require 'formula'

class Openwsman < Formula
  homepage 'http://openwsman.github.io'
  url "https://github.com/Openwsman/openwsman/archive/v2.3.6.tar.gz"
  sha1 'ed8cfc3c1705e8aecf4a64d2285e69bdfc0f11ff'

  depends_on "libxml2"
  depends_on "sblim-sfcc"
  depends_on "automake"   => :build
  depends_on "autoconf"   => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build

  def install
    system "./autoconfiscate.sh"
    system "./configure",
                          "--disable-more-warnings",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
