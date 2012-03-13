require 'formula'

class Jmeter < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/apache-jmeter-2.6.tgz'
  homepage 'http://jakarta.apache.org/jmeter/'
  md5 '87c13f4e1b32b5ec5f2a77426d624b4d'

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
    (bin+'jmeter').write startup_script('jmeter')
  end
end
