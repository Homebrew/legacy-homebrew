require 'formula'

class Sshuttle < Formula
  url 'https://github.com/apenwarr/sshuttle/zipball/sshuttle-0.61'
  homepage 'https://github.com/apenwarr/sshuttle'
  md5 'ab9a1621eac89533b6803dc5608a6457'

  head 'https://github.com/apenwarr/sshuttle.git'

  def install
    libexec.install Dir['*']
    (bin+'sshuttle').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/sshuttle "$@"
    EOS
  end
end
