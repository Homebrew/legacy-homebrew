require 'formula'

class Jetty < Formula
  homepage 'http://www.eclipse.org/jetty/'
  url 'http://eclipse.org/downloads/download.php?file=/jetty/9.2.0.v20140526/dist/jetty-distribution-9.2.0.v20140526.tar.gz&r=1'
  version '9.2.0'
  sha1 'f643745f9a7a4b03a05b1ff0bec6c1176e9e521e'

  def install
    libexec.install Dir['*']
    (libexec+'logs').mkpath

    bin.mkpath
    Dir.glob("#{libexec}/bin/*.sh") do |f|
      scriptname = File.basename(f, '.sh')
      (bin+scriptname).write <<-EOS.undent
        #!/bin/bash
        JETTY_HOME=#{libexec}
        #{f} "$@"
      EOS
      chmod 0755, bin+scriptname
    end
  end
end
