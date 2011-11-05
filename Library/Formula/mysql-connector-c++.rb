require 'formula'

class MysqlConnectorCxx < Formula
  url 'http://mysql.he.net/Downloads/Connector-C++/mysql-connector-c++-1.1.0.tar.gz'
  homepage 'http://dev.mysql.com/downloads/connector/cpp/'
  md5 '0981bda6548a8c8233ffce2b6e4b2a23'

  depends_on 'cmake' => :build
  depends_on 'boost' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    ENV.j1
    system "make install"
  end
end
