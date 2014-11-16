require 'formula'

class PaxRunner < Formula
  homepage 'http://team.ops4j.org'
  url 'http://repo1.maven.org/maven2/org/ops4j/pax/runner/pax-runner-assembly/1.8.6/pax-runner-assembly-1.8.6-jdk15.tar.gz'
  version '1.8.6'
  sha1 '6491205be3f609e2df35ef789c8d82f65461a39c'

  def install
    (bin+'pax-runner').write <<-EOS.undent
      #!/bin/sh
      exec java $JAVA_OPTS -cp  #{libexec}/bin/pax-runner-#{version}.jar org.ops4j.pax.runner.Run "$@"
    EOS

    libexec.install Dir['*']
  end
end
