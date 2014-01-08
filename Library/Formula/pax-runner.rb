require 'formula'

class PaxRunner < Formula
  homepage 'http://team.ops4j.org'
  url 'http://repo1.maven.org/maven2/org/ops4j/pax/runner/pax-runner-assembly/1.8.5/pax-runner-assembly-1.8.5-jdk15.tar.gz'
  version '1.8.5'
  sha1 '7cd301b6a20e4a83f8b5dfc84a7250d43f24eb10'

  def install
    (bin+'pax-runner').write <<-EOS.undent
      #!/bin/sh
      exec java $JAVA_OPTS -cp  #{libexec}/bin/pax-runner-#{version}.jar org.ops4j.pax.runner.Run "$@"
    EOS

    libexec.install Dir['*']
  end
end
