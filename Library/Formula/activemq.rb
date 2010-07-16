require 'formula'

class Activemq <Formula
  url 'http://www.gossipcheck.com/mirrors/apache/activemq/apache-activemq/5.3.2/apache-activemq-5.3.2-bin.tar.gz'
  homepage 'http://activemq.apache.org/'
  md5 '17574ad1ee6cc3727bf7447c2421097b'

  aka 'apache-activemq'

  def skip_clean? path
    path == libexec + 'webapps/admin/WEB-INF/jsp'
  end

  def startup_script
    <<-EOS.undent
      #!/usr/bin/env bash
      exec #{libexec}/bin/activemq
    EOS
  end

  def install
    rm_rf Dir['bin/linux-x86-*']

    prefix.install %w{ LICENSE NOTICE README.txt }
    libexec.install Dir['*']
    (bin+'activemq').write startup_script
  end

  def caveats
    <<-EOS.undent
    ActiveMQ was installed to:
      #{libexec}

    `activemq` is a startup script that will run the server
    from its installed location.
    EOS
  end
end
