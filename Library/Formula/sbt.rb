require 'formula'

class Sbt < Formula
  homepage 'http://www.scala-sbt.org'
  url 'http://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.12.4/sbt-launch.jar'
  version '0.12.4'
  sha1 '701af98879a5c2d89c089d69e96e5d1c3bcfafaa'

  devel do
    url 'http://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.0-RC1/sbt-launch.jar'
    sha1 '44a212e646866fc64b23d2f7a1dc02c986b7e7f1'
    version '0.13.0-RC1'
  end

  def install
    (bin+'sbt').write <<-EOS.undent
      #!/bin/sh
      test -f ~/.sbtconfig && . ~/.sbtconfig
      exec java -Xmx512M ${SBT_OPTS} -jar #{libexec}/sbt-launch.jar "$@"
    EOS

    libexec.install Dir['*']
  end

  def caveats;  <<-EOS.undent
    You can use $SBT_OPTS to pass additional JVM options to SBT.
    For convenience, this can specified in `~/.sbtconfig`.

    For example:
        SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"
    EOS
  end
end
