require 'formula'

class MysqlConnectorCxx < Formula
  homepage 'http://dev.mysql.com/downloads/connector/cpp/'
  url 'http://mysql.he.net/Downloads/Connector-C++/mysql-connector-c++-1.1.5.tar.gz'
  sha1 '0b33f74049227d330da0a37ce919b8cd695a9584'

  class MysqlClient < Requirement
    fatal true
    default_formula "mysql"

    satisfy { which 'mysql' }
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => :build
  depends_on "openssl"
  depends_on MysqlClient

  def install
    system "cmake", ".", *std_cmake_args
    ENV.j1
    system "make install"
  end
end
