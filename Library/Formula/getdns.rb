require "formula"

class Getdns < Formula
  homepage "http://getdnsapi.net"
  url "http://getdnsapi.net/dist/getdns-0.1.0.tar.gz"
  sha1 "176d7a6d16ec5e0cfb8d34a303be1ccdbb0b4e5d"

  depends_on 'ldns'
  depends_on 'unbound'
  depends_on 'libidn'
  depends_on 'libevent'
  depends_on 'libuv' => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
