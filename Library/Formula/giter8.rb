require 'formula'

class Giter8 < Formula
  homepage 'https://github.com/n8han/giter8'
  url "https://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.12.1/sbt-launch.jar"
  sha1 '45c28c7c6328d6ecf8e9dc51003a0f1af71516ad'
  version '0.5.3'

  def exec_script
     <<-EOS
#!/bin/sh
exec java -Xmx512M -jar #{prefix}/sbt-launch.jar @giter8.launchconfig "$@"
    EOS
  end

  def config_script
    <<-EOS
[app]
  version: 0.5.3
  org: net.databinder.giter8
  name: giter8
  class: giter8.Giter8
[scala]
  version: 2.9.1
[repositories]
  local
  scala-tools-releases
  maven-central
[boot]
  directory: #{prefix}/boot
    EOS
  end

  def install
    (bin+'g8').write exec_script
    (prefix+'giter8.launchconfig').write config_script
    prefix.install 'sbt-launch.jar'
  end

  def caveats; <<-EOS.undent
    Giter8 will download the Scala runtime from scala-tools.org
    and the rest of the giter8 binaries the first time you run it.
    You can do that now running "g8".

    If the download of a resources fails, try cleaning your
    ~/.ivy2/cache folder and rerun / reinstall giter8.
EOS
  end
end
