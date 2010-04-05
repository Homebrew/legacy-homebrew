require 'formula'

class Sbt <Formula
  JAR = 'sbt-launch-0.7.2.jar'
  url "http://simple-build-tool.googlecode.com/files/#{JAR}"
  homepage 'http://code.google.com/p/simple-build-tool'
  md5 '9d02c8d4720e38492262a8b0266b077e'

  def install
    (bin+'sbt').write <<-EOS
#!/bin/sh

java -Xmx512M -jar #{prefix}/#{JAR} "$@"
EOS

    prefix.install Dir['*']
  end
end
