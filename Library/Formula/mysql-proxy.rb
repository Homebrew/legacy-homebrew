require 'formula'

class MysqlProxy <Formula
  url 'http://launchpad.net/mysql-proxy/0.8/0.8.0/+download/mysql-proxy-0.8.0.tar.gz'
  homepage 'https://launchpad.net/mysql-proxy'
  md5 'b6a9748d72e8db7fe3789fbdd60ff451'

  depends_on 'pkg-config'
  depends_on 'glib'
  depends_on 'libevent'
  depends_on 'lua'

  def install
    if `which mysql_config`.chomp.empty?
      opoo "`mysql_config` not found"
      puts "This software requires the MySQL client libraries."
      puts "You can install them via Homebrew with one of these:"
      puts "  brew install mysql-connector-c"
      puts "  brew install mysql [--client-only]"
      puts "Without the client libraries, this formula will fail to compile."
    end

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
