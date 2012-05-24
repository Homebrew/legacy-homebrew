require 'formula'

class MysqlConnectorC < Formula
  homepage 'http://dev.mysql.com/downloads/connector/c/6.0.html'
  url 'http://mysql.llarian.net/Downloads/Connector-C/mysql-connector-c-6.0.2.tar.gz'
  md5 'f922b778abdd25f7c1c95a8329144d56'

  depends_on 'cmake' => :build

  fails_with :llvm do
    build 2334
    cause "Unsupported inline asm"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system 'make'
    ENV.j1
    system 'make install'
  end
end
