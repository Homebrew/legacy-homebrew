class MysqlClientRequirement < Requirement
  fatal true
  default_formula "mysql"
  satisfy { which "mysql" }
end

class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.5.tar.gz"
  sha256 "f3696726da29d56e0daad7046b30aa51444360a3ff112c079eb942929eb1cce8"

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on MysqlClientRequirement

  def install
    system "cmake", ".", *std_cmake_args
    ENV.j1
    system "make", "install"
  end
end
