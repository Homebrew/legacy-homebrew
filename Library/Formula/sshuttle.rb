require 'formula'

class Sshuttle <Formula
  url 'https://github.com/apenwarr/sshuttle/tarball/sshuttle-0.44'
  homepage 'https://github.com/apenwarr/sshuttle'
  md5 'c0d81604a8d864d0f52f2b6137b655a7'
  version '0.44'

  head 'git://github.com/apenwarr/sshuttle.git'

  def install
    libexec.install Dir['*']
    (bin+'sshuttle').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/main.py "$@"
    EOS
  end
end
