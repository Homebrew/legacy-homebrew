require 'formula'

class Activemq < Formula
  homepage 'http://activemq.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=/activemq/5.9.1/apache-activemq-5.9.1-bin.tar.gz'
  sha1 '03c0730e8de406ad8dc243f5834bf5b74492c5e8'

  skip_clean 'libexec/webapps/admin/WEB-INF/jsp'

  def install
    rm_rf Dir['bin/linux-x86-*']

    prefix.install_metafiles
    libexec.install Dir['*']

    bin.write_exec_script libexec/'bin/activemq'
    bin.write_exec_script libexec/'bin/activemq-admin'
  end
end
