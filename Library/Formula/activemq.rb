require 'formula'

class Activemq < Formula
  homepage 'http://activemq.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=activemq/apache-activemq/5.7.0/apache-activemq-5.7.0-bin.tar.gz'
  sha1 '372363dd98d7952de33f9872ddb5bbaaf05f806b'

  skip_clean 'libexec/webapps/admin/WEB-INF/jsp'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{name}" "$@"
    EOS
  end

  def install
    rm_rf Dir['bin/linux-x86-*']

    prefix.install %w{ LICENSE NOTICE README.txt }
    libexec.install Dir['*']

    (bin+'activemq-admin').write startup_script('activemq-admin')
    (bin+'activemq').write startup_script('activemq')
  end
end
