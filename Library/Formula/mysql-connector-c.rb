require 'brewkit'

class MysqlConnectorC <Formula
  @homepage='http://dev.mysql.com/downloads/connector/c/6.0.html'
  @url='http://mysql.llarian.net/Downloads/Connector-C/mysql-connector-c-6.0.2.tar.gz'
  @md5='67e478df66e8f66536e54388cfa29854'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system 'make install'
  end
end
