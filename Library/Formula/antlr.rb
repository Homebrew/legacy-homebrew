require 'formula'

class Antlr < Formula
  url "http://www.antlr.org/download/antlr-3.4-complete.jar"
  version '3.4'
  homepage 'http://www.antlr.org/'
  md5 '1b91dea1c7d480b3223f7c8a9aa0e172'

  def install
    prefix.install "antlr-3.4-complete.jar"
    (bin+"antlr-3.4").write <<-EOS.undent
    #!/bin/sh
    java -jar #{prefix}/antlr-3.4-complete.jar "$@"
    EOS
  end
end
