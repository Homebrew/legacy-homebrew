require 'formula'

class Jetty < Formula
  homepage 'http://www.eclipse.org/jetty/'
  url 'http://eclipse.org/downloads/download.php?file=/jetty/stable-9/dist/jetty-distribution-9.0.2.v20130417.tar.gz&r=1'
  version '9.0.2'
  sha1 '920eab8d41754cb9e68f050d98440a8f2a78739f'

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
