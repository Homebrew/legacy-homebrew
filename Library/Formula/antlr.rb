require "formula"

class Antlr < Formula
  homepage "http://www.antlr.org/"
  url "http://www.antlr.org/download/antlr-4.4-complete.jar"
  sha1 "735569b1fa92a0d3f14bb5f3a3ffa713f5be4d1e"

  def install
    prefix.install "antlr-#{version}-complete.jar"
    bin.write_jar_script prefix/"antlr-#{version}-complete.jar", "antlr4"
    (bin+"grun").write <<-EOS.undent
      #!/bin/bash
      java -classpath #{prefix}/antlr-#{version}-complete.jar:. org.antlr.v4.runtime.misc.TestRig "$@"
    EOS
  end
end
