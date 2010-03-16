require 'formula'

class Sbt <Formula
  JAR = 'sbt-launch-0.7.0.jar'
  url "http://simple-build-tool.googlecode.com/files/#{JAR}"
  homepage 'http://code.google.com/p/simple-build-tool'
  md5 '19275aa32369683c6a92de9394da822b'

  def install
    (bin+'sbt').write <<-EOS
#!/bin/sh

java -Xmx512M -jar #{prefix}/#{JAR} "$@"
EOS

    prefix.install Dir['*']
  end
end
