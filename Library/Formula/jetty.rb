require 'formula'

class Jetty < Formula
  url 'http://download.eclipse.org/jetty/8.0.4.v20111024/dist/jetty-distribution-8.0.4.v20111024.tar.gz'
  homepage 'http://www.eclipse.org/jetty/'
  md5 '8da01a64a0042ad43babbd92a1b8dcbf'

  skip_clean :all

  def install
    rm_rf Dir['bin/*.{cmd,bat]}']

    libexec.install Dir['*']
    (libexec+'logs').mkpath

    bin.mkpath
    Dir["#{libexec}/bin/*.sh"].each do |f|
      scriptname = File.basename(f, '.sh')
      (bin+scriptname).write <<-EOS.undent
        #!/bin/bash
        JETTY_HOME=#{libexec}
        #{f} $@
      EOS
      chmod 0755, bin+scriptname
    end
  end
end
