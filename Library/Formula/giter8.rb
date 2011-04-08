require 'formula'

class Giter8 < Formula
  url "http://simple-build-tool.googlecode.com/files/sbt-launch-0.7.4.jar"
  homepage 'http://github.com/n8han/giter8'
  md5 '8903fb141037056a497925f3efdb9edf'
  version '0.2.0'

  def exec_script
     <<-EOS
#!/bin/sh
exec java -Xmx512M -jar #{prefix}/sbt-launch-0.7.4.jar @giter8.launchconfig "$@"
    EOS
  end

  def config_script
    <<-EOS
[app]
  version: 0.2.0
  org: net.databinder
  name: giter8
  class: giter8.Giter8
[scala]
  version: 2.8.1
[repositories]
  local
  maven-local
  scala-tools-releases
  maven-central
  clapper: http://maven.clapper.org/
  databinder: http://databinder.net/repo/
[boot]
  directory: #{prefix}/boot
    EOS
  end

  def install
    (bin+'g8').write exec_script
    (prefix+'giter8.launchconfig').write config_script
    prefix.install 'sbt-launch-0.7.4.jar'
  end

  def caveats; <<-EOS
    Giter8 will download the Scala runtime from scala-tools.org
    and the rest of the giter8 binaries the first time you run it.
    You can do that now running "g8".

    If the download of a resources fails, try cleaning your
    ~/.ivy2/cache folder and rerun / reinstall giter8.
EOS
  end
end
