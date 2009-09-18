require 'brewkit'

class MysqlConnectorC <Formula
  @homepage='http://dev.mysql.com/downloads/connector/c/6.0.html'
  @url='http://mysql.llarian.net/Downloads/Connector-C/mysql-connector-c-6.0.1.tar.gz'
  @md5='348a869fa72957062ea4e7ad3865623c'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system 'make install'
  end
end
