require "formula"

class Sbt < Formula
  homepage "http://www.scala-sbt.org"
  url "https://dl.bintray.com/sbt/native-packages/sbt/0.13.7/sbt-0.13.7.tgz"
  sha1 "0ee4df9a5bd6dc478f9007ebdb24bacd1cf2731c"

  bottle do
    cellar :any
    sha1 "4ca22cd7cca26e940eb8634a9226f2051b098053" => :yosemite
    sha1 "db2296a8b05c7fbe2db23dfe8b53d575df2ef164" => :mavericks
    sha1 "d97a9693ea2475d8f671cfe22b50a4a0188b421a" => :mountain_lion
  end

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="${sbt_home}/conf/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    inreplace "bin/sbt-launch-lib.bash", "${sbt_home}/bin/sbt-launch.jar", "#{libexec}/sbt-launch.jar"

    libexec.install "bin/sbt", "bin/sbt-launch-lib.bash", "bin/sbt-launch.jar"
    etc.install "conf/sbtopts"

    (bin/"sbt").write <<-EOS.undent
      #!/bin/sh
      if [ -f "$HOME/.sbtconfig" ]; then
        echo "Use of ~/.sbtconfig is deprecated, please migrate global settings to #{etc}/sbtopts" >&2
        . "$HOME/.sbtconfig"
      fi
      exec "#{libexec}/sbt" "$@"
    EOS
  end

  def caveats;  <<-EOS.undent
    You can use $SBT_OPTS to pass additional JVM options to SBT:
       SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

    This formula is now using the standard typesafe sbt launcher script.
    Project specific options should be placed in .sbtopts in the root of your project.
    Global settings should be placed in #{etc}/sbtopts
    EOS
  end
end
