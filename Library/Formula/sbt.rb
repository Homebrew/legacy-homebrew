require "formula"

class Sbt < Formula
  homepage "http://www.scala-sbt.org"
  url "http://dl.bintray.com/sbt/native-packages/sbt/0.13.5/sbt-0.13.5.tgz"
  sha1 "9a77a6971478ebf2272735f40ab65443dcb60259"

  def install
    inreplace "bin/sbt", 'etc_sbt_opts_file="${sbt_home}/conf/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
    inreplace "bin/sbt", '/etc/sbt/sbtopts', "#{etc}/sbtopts"

    inreplace "bin/sbt-launch-lib.bash" do |s|
      s.gsub! '${sbt_home}/bin/sbt-launch.jar', "#{libexec}/sbt-launch.jar"

      if File.file?("#{ENV['HOME']}/.sbtconfig")
        opoo "Use of ~/.sbtconfig is deprecated.  Please migrate global settings to #{etc}/sbtopts"
        s << "\n\ntest -f \"$HOME/.sbtconfig\" && source \"$HOME/.sbtconfig\""
      end
    end

    bin.install "bin/sbt", "bin/sbt-launch-lib.bash"
    libexec.install "bin/sbt-launch.jar"
    etc.install "conf/sbtopts"
  end

  def caveats;  <<-EOS.undent
    You can use $SBT_OPTS to pass additional JVM options to SBT.

    For example:
       SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"

    This formula is now using the standard typesafe sbt launcher script.
    Project specific options should be placed in .sbtopts in the root of your project.
    Global settings should be placed in #{etc}/sbtopts
    EOS
  end
end
