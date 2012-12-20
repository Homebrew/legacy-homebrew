require 'formula'

class MysqlProxy < Formula
  homepage 'https://launchpad.net/mysql-proxy'
  url 'https://launchpad.net/mysql-proxy/0.8/0.8.2/+download/mysql-proxy-0.8.2.tar.gz'
  sha1 '3ae4f2f68849cfd95eeaf033af8df78d643dbf4d'

  depends_on :mysql
  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libevent'
  depends_on 'lua'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          # Ugh, don't dump these directly into /usr/local/include.
                          # Use a subfolder, please.
                          "--includedir=#{include}/mysqlproxy"
    system "make install"
    # Copy over the example scripts
    (share+"mysqlproxy").install Dir['examples/*.lua']
  end
end
