require 'formula'

class Sshuttle <Formula
  url 'https://github.com/apenwarr/sshuttle/tarball/sshuttle-0.43'
  homepage 'https://github.com/apenwarr/sshuttle'
  md5 '590352aa7cbaad90c8f46dab64b829f4'
  version '0.43'

  head 'git://github.com/apenwarr/sshuttle.git'

  def install
    libexec.install Dir['*']
    (bin+'sshuttle').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/main.py "$@"
    EOS
  end
end
