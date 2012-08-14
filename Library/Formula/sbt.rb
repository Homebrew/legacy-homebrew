require 'formula'

class Sbt < Formula
  homepage 'http://github.com/harrah/xsbt/'
  url 'http://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.11.3-2/sbt-launch.jar'
  version '0.11.3-2'
  md5 'b8d0d2cd7000f2de29a2cda65e7809e5'

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
