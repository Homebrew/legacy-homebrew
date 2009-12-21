require 'formula'

class Sbt <Formula
  JAR = 'sbt-launcher-0.5.5.jar'
  url "http://simple-build-tool.googlecode.com/files/#{JAR}"
  homepage 'http://code.google.com/p/simple-build-tool'
  md5 'e3593448b3be17ce1666c6241b8d2f90'

  def install
    (bin+'sbt').write <<-EOS
#!/bin/sh

java -Xmx512M -jar #{prefix}/#{JAR} "$@"
EOS

    prefix.install Dir['*']
  end
end
