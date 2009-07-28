require 'brewkit'

class MysqlConnectorC <Formula
  @homepage='http://dev.mysql.com/downloads/connector/c/6.0.html'
  @url='http://mysql.llarian.net/Downloads/Connector-C/mysql-connector-c-6.0.1.tar.gz'
  @md5='348a869fa72957062ea4e7ad3865623c'

  def deps
    BinaryDep.new 'cmake'
  end

  def install
    system "cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX=#{prefix}"
    system 'make'
    system 'make install'
  end
end
