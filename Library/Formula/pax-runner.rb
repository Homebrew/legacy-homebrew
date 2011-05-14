require 'formula'

class PaxRunner < Formula
  version '1.7.1'
  url 'http://repo1.maven.org/maven2/org/ops4j/pax/runner/pax-runner-assembly/1.7.1/pax-runner-assembly-1.7.1-jdk15.tar.gz'
  homepage 'http://paxrunner.ops4j.org'
  md5 '021f993f000dd9b6d55a62f41621ae24'

  def install
    (bin+'pax-runner').write <<-EOS.undent
      #!/bin/sh
      exec java $JAVA_OPTS -cp  #{libexec}/bin/pax-runner-1.7.1.jar org.ops4j.pax.runner.Run "$@"
    EOS

    libexec.install Dir['*']
  end
end
