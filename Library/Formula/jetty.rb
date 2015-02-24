require 'formula'

class Jetty < Formula
  homepage "http://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.2.7.v20150116/dist/jetty-distribution-9.2.7.v20150116.tar.gz"
  version "9.2.7.v20150116"
  sha1 "90d3f9ef886696a62bd93012f463d0054282b395"

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
