require 'formula'

class Sbt < Formula
  homepage 'http://www.scala-sbt.org'
  url 'http://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.2/sbt-launch.jar'
  version '0.13.2'
  sha1 'd3237161dc38afd796d9e84ff202f8418cff98e2'

  devel do
    url 'http://repo.typesafe.com/typesafe/ivy-snapshots/org.scala-sbt/sbt-launch/0.13.5-20140412-061917/sbt-launch.jar'
    version '0.13.5-20140412-061917'
    sha1 '06c8bef75e9162c0c3c6220a21f0b53ea8ca93ab'
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
    For convenience, this can be specified in `~/.sbtconfig`.

    For example:
        SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"
    EOS
  end
end
