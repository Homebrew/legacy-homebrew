require 'formula'

class MysqlConnectorCxx < Formula
  url 'http://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-1.1.0.tar.gz/from/http://mysql.he.net/'
  homepage 'http://dev.mysql.com/downloads/connector/cpp/'
  version '1.1.0'
  md5 '0981bda6548a8c8233ffce2b6e4b2a23'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake . #{std_cmake_parameters}"
    ENV.j1
    system "make install"
  end

end
