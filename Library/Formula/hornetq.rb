require 'formula'

class Hornetq < Formula
  url 'http://downloads.jboss.org/hornetq/hornetq-2.2.5.Final.tar.gz'
  homepage 'http://www.jboss.org/hornetq'
  md5 'e83f9c87320d1d0fc5d836384110ca7d'

  version '2.2.5'

  def wrapper_script target
    <<-EOS.undent
      #!/bin/bash
      cd #{libexec}/bin/
      ./#{target} "$@"
    EOS
  end

  def install
    libexec.install Dir['*']
    bin.mkpath
    (bin+'hornet-start').write wrapper_script('run.sh')
    (bin+'hornet-stop').write wrapper_script('stop.sh')
  end

  def caveats; <<-EOF.undent
    HornetQ has been installed to:
      #{libexec}

    `run.sh` and `stop.sh` have been wrapped as`hornet-start` and `hornet-stop`
    to avoid naming conflicts.
    EOF
  end
end
