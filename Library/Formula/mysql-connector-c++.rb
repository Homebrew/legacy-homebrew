require 'formula'

class MysqlConnectorCxx < Formula
  homepage 'http://dev.mysql.com/downloads/connector/cpp/'
  url 'http://mysql.he.net/Downloads/Connector-C++/mysql-connector-c++-1.1.3.tar.gz'
  sha1 'b817dccf3a4e340b6a972028ceb7eededaaebd6f'

  depends_on 'cmake' => :build
  depends_on 'boost' => :build

  #MySQL packages
  if build.include? 'with-mariadb'
    depends_on 'mariadb'
  elsif build.include? 'with-percona-server'
    depends_on 'percona-server'
  else
    depends_on 'mysql'
  end

  def install
    system "cmake", ".", *std_cmake_args
    ENV.j1
    system "make install"
  end
  
  def caveats
    <<-EOS.undent
      MySQL to compile, by default will use Oracle MySQL
        Select MariaDB: --with-mariadb
         or
        Select Percona-Server: --with-percona-server
    EOS
  end
end
