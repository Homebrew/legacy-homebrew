class MysqlConnectorJava < Formula
  desc "MySQL database connector for Java applications"
  homepage "https://dev.mysql.com/downloads/connector/j/"
  url "http://dev.mysql.com/get/Downloads/Connector-Java/mysql-connector-java-5.1.38.tar.gz"
  sha256 "fa6232a0bcf67dc7d9acac9dc58910644e50790cbd8cc2f854e2c17f91b2c224"

  bottle :unneeded

  def install
    libexec.install "mysql-connector-java-#{version}-bin.jar" => "mysql-connector-java.jar"
  end

  test do
    system "#{bin}/mysql_config", "--cflags"
    system "#{bin}/mysql_config", "--include"
    system "#{bin}/mysql_config", "--libs"
  end
end
