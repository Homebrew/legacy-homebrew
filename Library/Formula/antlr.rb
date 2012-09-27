require 'formula'

class Antlr < Formula
  homepage 'http://www.antlr.org/'
  url "http://www.antlr.org/download/antlr-3.4-complete.jar"
  sha1 '5cab59d859caa6598e28131d30dd2e89806db57f'

  def install
    prefix.install "antlr-3.4-complete.jar"
    (bin+"antlr-3.4").write <<-EOS.undent
    #!/bin/sh
    java -jar #{prefix}/antlr-3.4-complete.jar "$@"
    EOS
  end
end
