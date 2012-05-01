require 'formula'

class MySqlInstalled < Requirement
  def message; <<-EOS.undent
    MySQL is required to install.

    You can install this with Homebrew using:
      brew install mysql-connector-c
        For MySQL client libraries only.

      brew install mysql
        For MySQL server.

    Or you can use an official installer from:
      http://dev.mysql.com/downloads/mysql/
    EOS
  end
  def satisfied?
    which 'mysql_config'
  end
  def fatal?
    true
  end
end

class MysqlProxy < Formula
  url 'http://launchpad.net/mysql-proxy/0.8/0.8.0/+download/mysql-proxy-0.8.0.tar.gz'
  homepage 'https://launchpad.net/mysql-proxy'
  md5 'b6a9748d72e8db7fe3789fbdd60ff451'

  depends_on MySqlInstalled.new
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
