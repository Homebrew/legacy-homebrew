require 'formula'

class MysqlConnectorC < Formula
  homepage 'http://dev.mysql.com/downloads/connector/c/'
  url 'http://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.3-src.tar.gz'
  sha1 'd70392aafb9ddeddd797c8131898e8727f904898'

  depends_on 'cmake' => :build

  conflicts_with 'mysql', 'mariadb', 'percona-server',
    :because => 'both install MySQL client libraries'

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
