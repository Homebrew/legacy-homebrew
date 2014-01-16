require 'formula'

class MysqlConnectorCxx < Formula
  homepage 'http://dev.mysql.com/downloads/connector/cpp/'
  url 'http://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.3-osx10.7-x86-64bit.tar.gz'
  sha1 'b817dccf3a4e340b6a972028ceb7eededaaebd6f'

  depends_on 'cmake' => :build
  depends_on 'boost' => :build

  def install
    system "cmake", ".", *std_cmake_args
    ENV.j1
    system "make install"
  end
end
