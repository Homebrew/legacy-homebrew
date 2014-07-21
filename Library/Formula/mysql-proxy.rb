require "formula"

class MysqlProxy < Formula
  homepage "http://dev.mysql.com/doc/refman/5.6/en/mysql-proxy.html"
  url "http://cdn.mysql.com/Downloads/MySQL-Proxy/mysql-proxy-0.8.4.tar.gz"
  sha1 "626cea599306f6cfb3a632a024ed034df08cf1b9"

  depends_on :mysql
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libevent"
  depends_on "lua"

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
