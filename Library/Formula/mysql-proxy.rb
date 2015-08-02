require "formula"

class MysqlProxy < Formula
  desc "Proxy for MySQL-Server"
  homepage "http://dev.mysql.com/doc/refman/5.6/en/mysql-proxy.html"
  url "https://cdn.mysql.com/Downloads/MySQL-Proxy/mysql-proxy-0.8.5.tar.gz"
  sha1 "e8599ef16bc7d16daffa654368e02ba73182bfbc"

  depends_on :mysql
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "flex"
  depends_on "libevent"
  depends_on "lua51"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # Ugh, don't dump these directly into /usr/local/include.
                          # Use a subfolder, please.
                          "--includedir=#{include}/mysqlproxy"
    system "make install"
    # Copy over the example scripts
    (share+"mysqlproxy").install Dir["examples/*.lua"]
  end
end
