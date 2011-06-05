require 'formula'

class Simian < Formula
  url 'http://www.harukizaemon.com/simian/simian-2.3.32.tar.gz'
  homepage 'http://www.harukizaemon.com/simian/index.html'
  md5 '3382f3ca3cb9d0190d89689bec3c92a9'

  def install
    libexec.install "bin/simian-2.3.32.jar"
    (bin+'simian').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/simian-2.3.32.jar" $@
    EOS
  end
end