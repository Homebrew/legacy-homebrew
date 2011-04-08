require 'formula'

class Jmeter < Formula
  url 'http://apache.mirror.rbftpnetworks.com//jakarta/jmeter/binaries/jakarta-jmeter-2.4.tgz'
  homepage 'http://jakarta.apache.org/jmeter/'
  md5 '01ac101b161643a77267baec99b3acfe'

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
