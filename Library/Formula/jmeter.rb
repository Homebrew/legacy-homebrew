require 'formula'

class Jmeter < Formula
  homepage 'http://jakarta.apache.org/jmeter/'
  url 'http://apache.webxcreen.org/jmeter/binaries/apache-jmeter-2.8.tgz'
  sha1 'e18cac4ab2b73dfcfe5d11e857905fa31c638563'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{name}" "$@"
    EOS
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install %w{ LICENSE NOTICE README }
    libexec.install Dir['*']
    (bin/'jmeter').write startup_script('jmeter')
  end
end
