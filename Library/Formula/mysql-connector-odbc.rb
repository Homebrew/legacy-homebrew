class MysqlConnectorOdbc < Formula
  desc "Standardized database driver"
  homepage "http://dev.mysql.com/doc/refman/5.1/en/connector-odbc.html"
  url "http://cdn.mysql.com/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.4-src.tar.gz"
  sha256 "a5f7a490f2958f2768d18b8a57f71909f9699a8619c82776b3ad1c02b8abce0d"

  depends_on "cmake" => :build
  depends_on "mysql"
  depends_on "unixodbc"
  depends_on "openssl"

  option :universal

  def install
    args = std_cmake_args
    args << "-DWITH_UNIXODBC=1"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    system "cmake", ".", *args
    system "make", "install"
  end
end
