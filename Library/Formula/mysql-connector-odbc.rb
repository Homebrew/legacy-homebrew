require "formula"

class MysqlConnectorOdbc < Formula
  homepage "http://dev.mysql.com/doc/refman/5.1/en/connector-odbc.html"
  url "http://cdn.mysql.com/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.2-src.tar.gz"
  sha1 "5507903fb14aadf6b7c14f7142eef2c9fff1250c"

  depends_on "cmake" => :build
  depends_on "mysql"
  depends_on "unixodbc"

  option :universal

  def install
    args = std_cmake_args
    args << "-DWITH_UNIXODBC=1"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    system 'cmake', ".", *args
    system 'make install'
  end
end
