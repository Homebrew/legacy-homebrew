class Fcgiwrap < Formula
  desc "CGI support for Nginx"
  homepage "http://nginx.localdomain.pl/wiki/FcgiWrap"
  url "https://github.com/gnosek/fcgiwrap/archive/1.1.0.tar.gz"
  sha256 "4c7de0db2634c38297d5fcef61ab4a3e21856dd7247d49c33d9b19542bd1c61f"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fcgi"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
