require 'formula'

class Jetty < Formula
  homepage "http://www.eclipse.org/jetty/"
  url "http://eclipse.org/downloads/download.php?file=/jetty/9.2.3.v20140905/dist/jetty-distribution-9.2.3.v20140905.tar.gz&r=1"
  version "9.2.3"
  sha1 "7ad9d6678e794aa483fe5b4517f9aa79caf8e8db"

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
