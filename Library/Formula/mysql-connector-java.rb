require 'formula'

class MysqlConnectorJava < Formula
  homepage 'http://dev.mysql.com/downloads/connector/j/'
  url 'http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.28.tar.gz'
  sha1 '872257139fbef8eed808e128eb90abc5d6effe5b'

  def install
    prefix.install_metafiles
    libexec.install Dir['*.jar']
    doc.install Dir['docs/*']
  end

end
