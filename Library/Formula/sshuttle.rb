require 'formula'

class Sshuttle < Formula
  url 'https://github.com/apenwarr/sshuttle/zipball/sshuttle-0.52'
  homepage 'https://github.com/apenwarr/sshuttle'
  md5 '0f41d963be481d0d136d2b82180d6fcd'
  version '0.52'

  head 'git://github.com/apenwarr/sshuttle.git'

  def install
    libexec.install Dir['*']
    (bin+'sshuttle').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/sshuttle "$@"
    EOS
  end
end
