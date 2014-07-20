require 'formula'

class Activemq < Formula
  homepage 'http://activemq.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=/activemq/5.10.0/apache-activemq-5.10.0-bin.tar.gz'
  sha1 'e08179216b4c7cbcd2024716c62c51434481fabf'

  skip_clean 'libexec/webapps/admin/WEB-INF/jsp'

  def install
    rm_rf Dir['bin/linux-x86-*']

    prefix.install_metafiles
    libexec.install Dir['*']

    bin.write_exec_script libexec/'bin/activemq'
    bin.write_exec_script libexec/'bin/activemq-admin'
  end
end
