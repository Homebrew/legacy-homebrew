class Ziproxy < Formula
  homepage "http://ziproxy.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ziproxy/ziproxy/ziproxy-3.3.1/ziproxy-3.3.1.tar.gz"
  sha1 "7c8db842754d1e3e90b42c3c37f9b15e932a6545"

  def install
    ENV["LDFLAGS"] = "-lresolv"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfgfile=#{etc}/ziproxy/ziproxy.conf"

    system "make", "install"

    (etc/"ziproxy").install Dir["etc/ziproxy/*"]
  end

  test do
    system "ziproxy -d -p ziproxy.pid"

    # Check ziproxy response headers
    result = `curl -s -I http://127.0.0.1:8080`.include?('ziproxy')

    system "ziproxy -k -p ziproxy.pid"

    result
  end
end
