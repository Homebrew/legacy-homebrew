require 'formula'

class Jetty < Formula
  homepage 'http://www.eclipse.org/jetty/'
  url 'http://eclipse.org/downloads/download.php?file=/jetty/9.0.5.v20130815/dist/jetty-distribution-9.0.5.v20130815.tar.gz&r=1'
  version '9.0.5'
  sha1 '9e5d237e2bf536ab9f6cdb80493a4ca27124d896'

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
