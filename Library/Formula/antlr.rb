require "formula"

class Antlr < Formula
  homepage "http://www.antlr.org/"
  url "http://www.antlr.org/download/antlr-4.3-complete.jar"
  sha1 "173cf3165fdc54dcb9d2c6bc30c9d2c178f348bc"

  def install
    prefix.install "antlr-#{version}-complete.jar"
    bin.write_jar_script prefix/"antlr-#{version}-complete.jar", "antlr4"
    (bin+"grun").write <<-EOS.undent
      #!/bin/bash
      java -classpath #{prefix}/antlr-#{version}-complete.jar:. org.antlr.v4.runtime.misc.TestRig "$@"
    EOS
  end
end
