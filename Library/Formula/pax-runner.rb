class PaxRunner < Formula
  desc "Tool to provision OSGi bundles"
  homepage "http://team.ops4j.org"
  url "http://repo1.maven.org/maven2/org/ops4j/pax/runner/pax-runner-assembly/1.8.6/pax-runner-assembly-1.8.6-jdk15.tar.gz"
  version "1.8.6"
  sha256 "42a650efdedcb48dca89f3e4272a9e2e1dcc6bc84570dbb176b5e578ca1ce2d4"

  def install
    (bin+"pax-runner").write <<-EOS.undent
      #!/bin/sh
      exec java $JAVA_OPTS -cp  #{libexec}/bin/pax-runner-#{version}.jar org.ops4j.pax.runner.Run "$@"
    EOS

    libexec.install Dir["*"]
  end
end
