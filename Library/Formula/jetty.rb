require 'formula'

class Jetty < Formula
  homepage "http://www.eclipse.org/jetty/"
  url "http://eclipse.org/downloads/download.php?file=/jetty/9.2.2.v20140723/dist/jetty-distribution-9.2.2.v20140723.tar.gz&r=1"
  version "9.2.2"
  sha1 "d11072421b40c300e64498a3ca7f728bf4af1758"

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
