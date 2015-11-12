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
  revision 1

  bottle do
    cellar :any
    sha256 "7d5d9aa9b0282fe738f95d3fdc9ac7c51da7a71ba9ad796a8fc9740e0ea0b8c6" => :el_capitan
    sha256 "78d2780ecfd29d744da4cb46092f498a4114619ecaa6efed8ed00f5bc998805b" => :yosemite
    sha256 "c198548bc4c4ff80724f6b4233625b933c8d83ca2d0254805a5d494f9b8b7680" => :mavericks
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
