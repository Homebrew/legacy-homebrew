require 'formula'

class ApacheActivemq <Formula
  url 'http://www.gossipcheck.com/mirrors/apache/activemq/apache-activemq/5.3.0/apache-activemq-5.3.0-bin.tar.gz'
  homepage 'http://activemq.apache.org/'
  md5 'f4b88a2b4ffd21cb804cdbd4f2e0152f'
  
  def skip_clean? path
    path == libexec + 'webapps/admin/WEB-INF/jsp'
  end
  
  def startup_script
    <<-EOS.undent
    #!/usr/bin/env bash
    # This is a startup script for Apache ActiveMQ that calls the 
    # real startup script installed to Homebrew's cellar.
    
    pushd #{libexec}
    bin/activemq
    popd
    EOS
  end

  def install
    rm_rf 'bin/linux-x86-32'
    rm_rf 'bin/linux-x86-64'
    
    prefix.install %w{ LICENSE NOTICE README.txt }
    libexec.install Dir['*']
    
    (bin+'activemq').write startup_script
  end
  
  def caveats
    <<-EOS.undent
    Software was installed to:
      #{libexec}
    EOS
  end
end
