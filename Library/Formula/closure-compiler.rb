require "formula"

class ClosureCompiler < Formula
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20140625.tar.gz"
  sha1 "48b13a84963321a77f68e814e44399f16884b278"

  head "https://github.com/google/closure-compiler.git"

  depends_on :ant => :build

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/compiler.jar", "closure-compiler"
  end
end
