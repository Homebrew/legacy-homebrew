require 'formula'

class Sbt <Formula
  JAR = 'sbt-launch-0.7.4.jar'
  url "http://simple-build-tool.googlecode.com/files/#{JAR}"
  homepage 'http://code.google.com/p/simple-build-tool/'
  md5 '8903fb141037056a497925f3efdb9edf'

  def install
    (bin+'sbt').write <<-EOS.undent
      #!/bin/sh
      if test -f ~/.sbtconfig; then
        . ~/.sbtconfig
      fi
      exec java -Xmx512M ${SBT_OPTS} -jar #{libexec}/#{JAR} "$@"
    EOS

    libexec.install Dir['*']
  end

  def caveats
    <<-EOS.undent
      You can use $SBT_OPTS to pass additional JVM options to SBT.
      For convenience, this can specified in `~/.sbtconfig`.

      For example:
          SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"
    EOS
  end
end
