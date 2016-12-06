require 'formula'

class MysqlConnectorJ < Formula
  homepage 'http://dev.mysql.com/downloads/connector/j/5.1.html'
  url 'http://downloads.mysql.com/archives/mysql-connector-java-5.1/mysql-connector-java-5.1.13.zip'
  md5 '2e1bbd848bc99fe1c8ae9ce980adc2c9'

  def install
    prefix.install ['README', 'COPYING', 'mysql-connector-java-5.1.13-bin.jar']
  end

  def caveats
    <<-EOS.undent

      To enable Java to find Connector/J, add the following to the
      front of your CLASSPATH:
        #{prefix}

      If this is an upgrade and you have previously added the symlinks
      to your CLASSPATH, you will need to modify it to the path specified
      above so it points to the new version.

    EOS
  end

end
