require 'formula'

class Hornetq < Formula
  desc "Multi-protocol, embeddable, clustered, asynchronous messaging system"
  homepage 'http://www.jboss.org/hornetq'
  url 'http://downloads.jboss.org/hornetq/hornetq-2.4.0.Final-bin.tar.gz'
  version '2.4.0'
  sha1 'b970f37625a951c23ca6d8a073e1ff400e0c28c6'

  def wrapper_script target
    <<-EOS.undent
      #!/bin/bash
      cd #{libexec}/bin/
      ./#{target} "$@"
    EOS
  end

  def install
    libexec.install Dir['*']
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
