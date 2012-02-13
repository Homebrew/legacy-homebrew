require 'formula'

class PaxRunner < Formula
  version '1.7.6'
  url 'http://repo1.maven.org/maven2/org/ops4j/pax/runner/pax-runner-assembly/'+ version + '/pax-runner-assembly-' + version + '-jdk15.tar.gz'
  homepage 'http://team.ops4j.org'
  md5 'f8bd2e0a902626baa58ae5a9df97b8e6'

  def install
    (bin+'pax-runner').write <<-EOS.undent
      #!/bin/sh
      exec java $JAVA_OPTS -cp  #{libexec}/bin/pax-runner-#{version}.jar org.ops4j.pax.runner.Run "$@"
    EOS

    libexec.install Dir['*']
  end
end
