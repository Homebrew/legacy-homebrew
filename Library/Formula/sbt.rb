require 'formula'

class Sbt <Formula
  JAR = 'sbt-launch-0.7.4.jar'
  url "http://simple-build-tool.googlecode.com/files/#{JAR}"
  homepage 'http://code.google.com/p/simple-build-tool'
  md5 '8903fb141037056a497925f3efdb9edf'

  def install
    (bin+'sbt').write <<-EOS
#!/bin/sh

java -Xmx512M -jar #{prefix}/#{JAR} "$@"
EOS

    prefix.install Dir['*']
  end
end
