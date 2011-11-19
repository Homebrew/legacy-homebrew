require 'formula'

class Jmeter < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/jakarta-jmeter-2.5.1.tgz'
  homepage 'http://jakarta.apache.org/jmeter/'
  md5 'e72f17c352fa4d3469d042e6542dd36d'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{name} $@
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
