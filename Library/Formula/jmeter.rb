require 'formula'

class Jmeter < Formula
  url 'http://apache.webxcreen.org/jmeter/binaries/apache-jmeter-2.7.tgz'
  homepage 'http://jakarta.apache.org/jmeter/'
  md5 '73435baa6ed99c528dacfa36c7e1f119'

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
