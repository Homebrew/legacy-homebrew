require 'formula'

class Sshuttle < Formula
  url 'https://github.com/apenwarr/sshuttle/zipball/sshuttle-0.54'
  homepage 'https://github.com/apenwarr/sshuttle'
  md5 'ccc36404fcda1cf411e4ec2ed37927e6'
  version '0.54'

  head 'https://github.com/apenwarr/sshuttle.git'

  def install
    libexec.install Dir['*']
    (bin+'sshuttle').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/sshuttle "$@"
    EOS
  end
end
