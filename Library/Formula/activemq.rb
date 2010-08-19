require 'formula'

class Activemq <Formula
  url 'http://www.gossipcheck.com/mirrors/apache/activemq/apache-activemq/5.3.2/apache-activemq-5.3.2-bin.tar.gz'
  homepage 'http://activemq.apache.org/'
  md5 '17574ad1ee6cc3727bf7447c2421097b'

  skip_clean 'libexec/webapps/admin/WEB-INF/jsp'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{name} $@
    EOS
  end

  def install
    rm_rf Dir['bin/linux-x86-*']

    prefix.install %w{ LICENSE NOTICE README.txt }
    libexec.install Dir['*']

    (bin+'activemq-admin').write startup_script('activemq-admin')
  end
end
