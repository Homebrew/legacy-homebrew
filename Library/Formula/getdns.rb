require "formula"

class Getdns < Formula
  homepage "http://getdnsapi.net"
  url "http://getdnsapi.net/dist/getdns-0.1.0.tar.gz"
  sha1 "75e588e30a59feb6c33d04a2e25e17de46dcc94a"

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
