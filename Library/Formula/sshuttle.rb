require 'formula'

class Sshuttle <Formula
  url 'https://github.com/apenwarr/sshuttle/tarball/sshuttle-0.43a'
  homepage 'https://github.com/apenwarr/sshuttle'
  md5 '51c736b890b9a7fcfc731e82f4279638'
  version '0.43a'

  head 'git://github.com/apenwarr/sshuttle.git'

  def install
    libexec.install Dir['*']
    (bin+'sshuttle').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/main.py "$@"
    EOS
  end
end
