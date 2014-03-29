require 'formula'

class MysqlConnectorCxx < Formula
  homepage 'http://dev.mysql.com/downloads/connector/cpp/'
  url 'http://mysql.he.net/Downloads/Connector-C++/mysql-connector-c++-1.1.3.tar.gz'
  sha1 'b817dccf3a4e340b6a972028ceb7eededaaebd6f'

  class MysqlClient < Requirement
    fatal true
    default_formula "mysql"

    satisfy { which 'mysql' }
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => :build
  depends_on MysqlClient

  def install
    system "cmake", ".", *std_cmake_args
    ENV.j1
    system "make install"
  end
end
