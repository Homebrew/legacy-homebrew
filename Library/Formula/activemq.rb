require 'formula'

class Activemq < Formula
  url 'http://www.reverse.net/pub/apache/activemq/apache-activemq/5.4.2/apache-activemq-5.4.2-bin.tar.gz'
  homepage 'http://activemq.apache.org/'
  md5 '804c1a4c01b80321a743648add1fdd06'

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
