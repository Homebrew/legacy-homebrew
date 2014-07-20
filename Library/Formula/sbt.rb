require "formula"

class Sbt < Formula
  homepage "http://www.scala-sbt.org"
  url "http://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.5/sbt-launch.jar"
  version "0.13.5"
  sha1 "f6308bd94bebdd37eb5e2fda732694ce0f34be74"

  def install
    (bin/"sbt").write <<-EOS.undent
      #!/bin/sh
      test -f ~/.sbtconfig && . ~/.sbtconfig
      exec java -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled ${SBT_OPTS} -jar #{libexec}/sbt-launch.jar "$@"
    EOS

    libexec.install Dir['*']
  end

  def caveats;  <<-EOS.undent
    You can use $SBT_OPTS to pass additional JVM options to SBT.
    For convenience, this can be specified in `~/.sbtconfig`.

    For example:
        SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"
    EOS
  end
end
