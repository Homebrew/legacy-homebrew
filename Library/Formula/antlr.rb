require 'formula'

class Antlr < Formula
  url "http://www.antlr.org/download/antlr-3.3-complete.jar"
  version '3.3'
  homepage 'http://www.antlr.org/'
  md5 '238becce7da69f7be5c5b8a65558cf63'

  def install
    prefix.install "antlr-3.3-complete.jar"
    (bin+"antlr-3.3").write <<-EOS.undent
    #!/bin/sh
    java -jar #{prefix}/antlr-3.3-complete.jar "$@"
    EOS
  end
end
