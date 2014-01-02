require 'formula'

class Sbt < Formula
  homepage 'http://www.scala-sbt.org'
  url 'http://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.1/sbt-launch.jar'
  version '0.13.1'
  sha1 '3a1718a467ca34380b0a356a2e1bb46813aff240'

  devel do
    url 'http://repo.typesafe.com/typesafe/ivy-snapshots/org.scala-sbt/sbt-launch/0.13.2-20131212-062515/sbt-launch.jar'
    version '0.13.2-20131212-062515'
    sha1 'c820c7cb68646cacba5c97f61667ae98e9bb6f77'
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
