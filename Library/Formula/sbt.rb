require 'formula'

class Sbt < Formula
  homepage 'http://www.scala-sbt.org'
  url 'http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt//0.12.2/sbt.tgz'
  version '0.12.2'
  sha1 '142bde6babbfed473e476fa62c1f70fe38e1ff84'

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']
    rm_rf Dir['bin/win-sbt']

    # Install files
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/sbt" => "sbt"
  end

  def caveats;  <<-EOS.undent
    You can use $SBT_OPTS to pass additional JVM options to SBT.

    For example:
        export SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"
    EOS
  end
end
