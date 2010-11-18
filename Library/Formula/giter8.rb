require 'formula'

class Giter8 <Formula
  JAR = 'sbt-launch-0.7.4.jar'
  url "http://simple-build-tool.googlecode.com/files/#{JAR}"
  homepage 'http://github.com/n8han/giter8'
  md5 '8903fb141037056a497925f3efdb9edf'
  version '0.1.1'

  def install
    (bin+'g8').write <<-EOS
#!/bin/sh
java -Xmx512M -jar #{libexec}/#{JAR} @giter8.launchconfig "$@"
EOS

    libexec.install Dir['*']
    (libexec+'giter8.launchconfig').write <<-EOS
[app]
  version: 0.1.1
  org: net.databinder
  name: giter8
  class: giter8.Giter8
[scala]
  version: 2.8.0
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

  def caveats; <<-EOS
    Giter8 will download some more stuff the first time you run it.
    You can do that now with "g8".
EOS
  end
end
