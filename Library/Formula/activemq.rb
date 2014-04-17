require 'formula'

class Activemq < Formula
  homepage 'http://activemq.apache.org/'
  url 'http://mirrors.koehn.com/apache/activemq/5.9.1/apache-activemq-5.9.1-bin.tar.gz'

  skip_clean 'libexec/webapps/admin/WEB-INF/jsp'

  def install
    rm_rf Dir['bin/linux-x86-*']

    prefix.install_metafiles
    libexec.install Dir['*']

    bin.write_exec_script libexec/'bin/activemq'
    bin.write_exec_script libexec/'bin/activemq-admin'
  end
end
