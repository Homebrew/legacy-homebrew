require 'formula'

class PaxRunner < Formula
  homepage 'http://team.ops4j.org'
  url 'http://repo1.maven.org/maven2/org/ops4j/pax/runner/pax-runner-assembly/1.7.6/pax-runner-assembly-1.7.6-jdk15.tar.gz'
  version '1.7.6'
  sha1 'db04e32011e41532a30f5163456368883cfc4261'

  def install
    (bin+'pax-runner').write <<-EOS.undent
      #!/bin/sh
      exec java $JAVA_OPTS -cp  #{libexec}/bin/pax-runner-#{version}.jar org.ops4j.pax.runner.Run "$@"
    EOS

    libexec.install Dir['*']
  end
end
