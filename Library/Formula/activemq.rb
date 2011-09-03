require 'formula'

class Activemq < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=activemq/apache-activemq/5.5.0/apache-activemq-5.5.0-bin.tar.gz'
  homepage 'http://activemq.apache.org/'
  md5 '81538848601793209099df5eef449d3c'

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
