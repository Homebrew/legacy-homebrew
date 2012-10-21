require 'formula'

class MysqlConnectorCxx < Formula
  homepage 'http://dev.mysql.com/downloads/connector/cpp/'
  url 'http://mysql.he.net/Downloads/Connector-C++/mysql-connector-c++-1.1.0.tar.gz'
  sha1 '9e8dd8025b5ef9707d3c1746dff6e8209198c5a2'

  depends_on 'cmake' => :build
  depends_on 'boost' => :build

  def install
    system "cmake", ".", *std_cmake_args
    ENV.j1
    system "make install"
  end
end
