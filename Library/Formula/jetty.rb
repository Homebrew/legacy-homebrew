require 'formula'

class Jetty < Formula
  homepage 'http://www.eclipse.org/jetty/'
  url 'http://eclipse.org/downloads/download.php?file=/jetty/8.1.8.v20121106/dist/jetty-distribution-8.1.8.v20121106.tar.gz&r=1'
  version '8.1.8'
  sha1 '19f6c1758d5b6d73702c08574062b63195a404b5'

  devel do
    url 'http://eclipse.org/downloads/download.php?file=/jetty/9.0.0.M4/dist/jetty-distribution-9.0.0.M4.tar.gz&r=1'
    version '9.0.0.M4'
    sha1 '98c4463b9fe1559e4e85cf75def5a21d2feef9e7'
  end

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
