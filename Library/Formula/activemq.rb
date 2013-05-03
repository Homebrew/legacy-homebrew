require 'formula'

class Activemq < Formula
  homepage 'http://activemq.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=activemq/apache-activemq/5.8.0/apache-activemq-5.8.0-bin.tar.gz'
  sha1 '426150ee260d3ab57e9c8674944ca7d171646056'

  skip_clean 'libexec/webapps/admin/WEB-INF/jsp'

  def install
    rm_rf Dir['bin/linux-x86-*']

    prefix.install_metafiles
    libexec.install Dir['*']

    bin.write_exec_script libexec/'bin/activemq'
    bin.write_exec_script libexec/'bin/activemq-admin'
  end
end
