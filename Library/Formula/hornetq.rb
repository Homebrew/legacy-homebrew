class Hornetq < Formula
  desc "Multi-protocol, embeddable, clustered, asynchronous messaging system"
  homepage "https://hornetq.jboss.org/"
  url "https://downloads.jboss.org/hornetq/hornetq-2.4.0.Final-bin.tar.gz"
  version "2.4.0"
  sha256 "a774083f6b56b368624eafd85002f7b9d15472690daf6dc6ca04c7561e66b013"

  bottle :unneeded

  def wrapper_script(target)
    <<-EOS.undent
      #!/bin/bash
      cd #{libexec}/bin/
      ./#{target} "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin+"hornet-start").write wrapper_script("run.sh")
    (bin+"hornet-stop").write wrapper_script("stop.sh")
  end

  def caveats; <<-EOF.undent
    HornetQ has been installed to:
      #{libexec}

    `run.sh` and `stop.sh` have been wrapped as`hornet-start` and `hornet-stop`
    to avoid naming conflicts.
    EOF
  end
end
