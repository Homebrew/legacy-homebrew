class Giter8 < Formula
  desc "Generate files and directories from templates in a git repo"
  homepage "https://github.com/n8han/giter8"
  url "https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.7/sbt-launch.jar"
  sha256 "9673ca4611e6367955ae068d5888f7ae665ab013c3e8435ffe2ca94318c6d607"
  # note: because sbt-launch dynamically downloads giter8 from the maven repos
  #   at first run (using the launchconfig mechanism), and not when the formula
  #   is installed, the above url and sha256 are related to sbt-launch.jar.
  #   The version below is that of giter8, and when upgrading this formula,
  #   one must check the giter8 version is available in maven repositories.
  version "0.6.8"

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
