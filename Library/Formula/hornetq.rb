require 'formula'

class Hornetq < Formula
  homepage 'http://www.jboss.org/hornetq'
  url 'http://downloads.jboss.org/hornetq/hornetq-2.2.14.Final.tar.gz'
  md5 'c204211128051b25689fbb8f844c900e'

  version '2.2.14'

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
