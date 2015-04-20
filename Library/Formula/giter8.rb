require "formula"

class Giter8 < Formula
  homepage "https://github.com/n8han/giter8"
  url "https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.7/sbt-launch.jar"
  sha1 "b407b2a76ad72165f806ac7e7ea09132b951ef53"
  version "0.6.6"

  def exec_script; <<-EOS.undent
    #!/bin/sh
    exec java -Xmx512M -jar #{prefix}/sbt-launch.jar @giter8.launchconfig "$@"
    EOS
  end

  def config_script; <<-EOS.undent
    [app]
      version: #{version}
      org: net.databinder.giter8
      name: giter8
      class: giter8.Giter8
    [scala]
      version: 2.10.4
    [repositories]
      local
      maven-central
      sonatype-releases: https://oss.sonatype.org/content/repositories/releases/
    [boot]
      directory: #{prefix}/boot
    EOS
  end

  def install
    (bin/"g8").write exec_script
    (prefix/"giter8.launchconfig").write config_script
    prefix.install "sbt-launch.jar"
  end

  def caveats; <<-EOS.undent
    Giter8 will download the Scala runtime and the rest of the
    giter8 binaries the first time you run it.
    You can do that now by running "g8".

    If the download of a resources fails, try cleaning your
    ~/.ivy2/cache folder and rerun / reinstall giter8.
    EOS
  end
end
