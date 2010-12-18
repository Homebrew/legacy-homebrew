require 'formula'

class Activemq <Formula
  url 'http://www.reverse.net/pub/apache/activemq/apache-activemq/5.4.1/apache-activemq-5.4.1-bin.tar.gz'
  homepage 'http://activemq.apache.org/'
  md5 '9cac63ecfd93852cda8dec35e5feb56a'

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
