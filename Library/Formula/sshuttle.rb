require 'formula'

class Sshuttle < Formula
  homepage 'https://github.com/apenwarr/sshuttle'
  url 'https://github.com/apenwarr/sshuttle/zipball/sshuttle-0.61'
  sha1 '81ad1b98b2aed6fefdc8993a72392969a1a9be01'

  head 'https://github.com/apenwarr/sshuttle.git'

  def install
    libexec.install Dir['*']
    (bin+'sshuttle').write <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/sshuttle "$@"
    EOS
  end
end
