require 'formula'

class Jmxsh < Formula
  version 'R5'
  url "http://jmxsh.googlecode.com/files/jmxsh-#{version}.jar"
  homepage 'http://code.google.com/p/jmxsh/'
  md5 '6d05b9eb044cfd82389f7bae71101ab8'

  def install
    libexec.install Dir["*"]
    (bin+'jmxsh').write <<-EOS.undent
      #!/bin/sh
      exec java -jar #{libexec}/jmxsh-#{version}.jar "$@"
    EOS
  end
end
