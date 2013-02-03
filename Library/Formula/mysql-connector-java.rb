require 'formula'

class MysqlConnectorJava < Formula
  homepage 'http://dev.mysql.com/downloads/connector/j/'
  url 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.22.tar.gz/from/http://cdn.mysql.com/'
  version '5.1.22'
  sha1 'fe50bca0ade43f6e814121ca8ee07dc2d6a0a584'

  def install
    doc.install Dir['docs/*']
    libexec.install Dir['*.jar']
  end

end
