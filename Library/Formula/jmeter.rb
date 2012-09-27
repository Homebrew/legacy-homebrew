require 'formula'

class Jmeter < Formula
  homepage 'http://jakarta.apache.org/jmeter/'
  url 'http://apache.webxcreen.org/jmeter/binaries/apache-jmeter-2.7.tgz'
  sha1 'cffa989e7b53dc06a9eaab3bd377b83acae4822b'

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
