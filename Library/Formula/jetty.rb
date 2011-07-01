require 'formula'

class Jetty < Formula
  url 'http://dist.codehaus.org/jetty/jetty-6.1.26/jetty-6.1.26.zip'
  homepage 'http://jetty.codehaus.org/jetty/index.html'
  md5 '0d9b2ae3feb2b207057358142658a11f'

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