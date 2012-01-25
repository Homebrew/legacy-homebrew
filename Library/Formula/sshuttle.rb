require 'formula'

class Sshuttle < Formula
  url 'https://github.com/apenwarr/sshuttle/zipball/sshuttle-0.60'
  homepage 'https://github.com/apenwarr/sshuttle'
  md5 'a3910e54fddb935cd9867f697270534f'

  head 'https://github.com/apenwarr/sshuttle.git'

  def install
    libexec.install Dir['*']
    (bin+'sshuttle').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/sshuttle "$@"
    EOS
  end
end
