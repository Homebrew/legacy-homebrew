require 'formula'

class Jetty < Formula
  homepage "http://www.eclipse.org/jetty/"
  url "http://download.eclipse.org/jetty/9.2.5.v20141112/dist/jetty-distribution-9.2.5.v20141112.tar.gz"
  version "9.2.5.v20141112"
  sha1 "30a7a34a7ac423fb15885a63f03bffc3669e4d9a"

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
