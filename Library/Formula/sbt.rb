class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "http://www.scala-sbt.org"
  url "https://dl.bintray.com/sbt/native-packages/sbt/0.13.11/sbt-0.13.11.tgz"
  sha256 "a36a6fbf6dd70afd93fb8db16c40e8ac00798fdddfa0b4c678786dc15617afa6"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb230c178ae02ea07b175c425905453535466915574f9ef3d850850e4a12094a" => :el_capitan
    sha256 "56bc9c0db2e8d225cf1218845bacfb7a2439898ac3dc1ca79c94919dd5c6f6fe" => :yosemite
    sha256 "3559009c0349c7ea597f300477d2a85c1e37eb1e2413f5f794e43e1644f60f28" => :mavericks
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
