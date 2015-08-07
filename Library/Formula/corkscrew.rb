class Corkscrew < Formula
  desc "Tunnel SSH through HTTP proxies"
  homepage "http://www.agroman.net/corkscrew/"
  url "http://www.agroman.net/corkscrew/corkscrew-2.0.tar.gz"
  sha256 "0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be"

  depends_on "libtool" => :build

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    require "open3"
    require "webrick"
    require "webrick/httpproxy"

    pid = fork do
      proxy = WEBrick::HTTPProxyServer.new :Port => 8080
      proxy.start
    end

    sleep 1

    begin
      Open3.popen3("#{bin}/corkscrew 127.0.0.1 8080 www.google.com 80") do |stdin, stdout, _|
        stdin.write "GET /index.html HTTP/1.1\r\n\r\n"
        assert_match "HTTP/1.1", stdout.gets("\r\n\r\n")
      end
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
