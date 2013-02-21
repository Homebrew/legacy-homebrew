require 'formula'

class Sbt < Formula
  homepage 'http://www.scala-sbt.org'
  url 'http://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.12.2/sbt-launch.jar'
  version '0.12.2'
  sha1 'ef6213597489edd8d1955086924f488949dd4975'

  def install
    (bin+'sbt').write <<-EOS.undent
      #!/bin/sh
      test -f ~/.sbt/config && . ~/.sbt/config
      if test "$1" = "debug"; then
        DEBUG_PARAM="-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=9999"
        exec java -Xmx512M ${DEBUG_PARAM} ${SBT_OPTS} -jar #{libexec}/sbt-launch.jar
      else
        exec java -Xmx512M ${SBT_OPTS} -jar #{libexec}/sbt-launch.jar "$@"
      fi
    EOS

    libexec.install Dir['*']
  end

  def caveats;  <<-EOS.undent
    You can use $SBT_OPTS to pass additional JVM options to SBT.
    For convenience, this can specified in `~/.sbt/config`.

    For example:
        SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"
    EOS
  end
end
