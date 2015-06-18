require 'formula'

class Fdkaac < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/v0.6.2.tar.gz"
  version "0.6.2"
  sha256 "de758d6e651e81e9be89d2972612fc5b96cb70321234c3339f35483b636458ad"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on 'pkg-config' => :build
  depends_on 'fdk-aac'

  def install
    system "autoreconf -i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
