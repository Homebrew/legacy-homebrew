class MysqlClientRequirement < Requirement
  fatal true
  default_formula "mysql"
  satisfy { which "mysql" }
end

class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.6.tar.gz"
  sha256 "ad710b3900cae3be94656825aa70319cf7a96e1ad46bf93e07275f3606f69447"

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on MysqlClientRequirement

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
