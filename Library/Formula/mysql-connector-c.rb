class MysqlConnectorC < Formula
  homepage "http://dev.mysql.com/downloads/connector/c/"
  url "http://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.6-src.tar.gz"
  sha256 "2222433012c415871958b61bc4f3683e1ebe77e3389f698b267058c12533ea78"

  depends_on "cmake" => :build

  conflicts_with "mysql", "mariadb", "percona-server",
    :because => "both install MySQL client libraries"

  fails_with :llvm do
    build 2334
    cause "Unsupported inline asm"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    ENV.j1
    system "make", "install"
  end

  test do
    system "#{bin}/mysql_config", "--cflags"
    system "#{bin}/mysql_config", "--include"
    system "#{bin}/mysql_config", "--libs"
  end
end
