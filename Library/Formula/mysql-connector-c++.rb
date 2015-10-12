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

  bottle do
    cellar :any
    sha256 "26173d993d062b886c01181dd1a1771e027e63842115590cc02b84c414d9a2cb" => :yosemite
    sha256 "78f67cbdd71e93d166cf0688db92ac8ca2e47050d438bb74988cc54f54ba2c96" => :mavericks
    sha256 "7898ce9ed80d30b6961775351a0c9e18d52b34c3d988609d3862d3aaa848efd1" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on MysqlClientRequirement

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
