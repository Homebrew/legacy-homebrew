require 'formula'

class Sshuttle < Formula
  url 'https://github.com/apenwarr/sshuttle/zipball/sshuttle-0.53'
  homepage 'https://github.com/apenwarr/sshuttle'
  md5 '352181fa9ad9648d4e181d19a2458c69'
  version '0.53'

  head 'https://github.com/apenwarr/sshuttle.git'

  def install
    libexec.install Dir['*']
    (bin+'sshuttle').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/sshuttle "$@"
    EOS
  end
end
