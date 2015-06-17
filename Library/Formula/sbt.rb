require "formula"

class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "http://www.scala-sbt.org"
  url "https://dl.bintray.com/sbt/native-packages/sbt/0.13.8/sbt-0.13.8.tgz"
  sha1 "155d6ff3bc178745ad4f951b74792b257ed14105"

  bottle do
    cellar :any
    sha256 "b04a205bd4dd390030b3384896020507a036ea5f897e8f34412ee74f4e55fe48" => :yosemite
    sha256 "dbe3bf9660a6391455b2f95a790229f755d81a364f88e52601b377bacfe5b6f6" => :mavericks
    sha256 "71ab799b398710a583647cad56b59086c7e0338f2419f039abe1666423fc9c80" => :mountain_lion
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
