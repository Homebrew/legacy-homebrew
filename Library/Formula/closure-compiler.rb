require "formula"

class ClosureCompiler < Formula
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20141023.tar.gz"
  sha1 "4551a74f0ccfd7e1de325d495b5f71f71a3b24c8"

  head "https://github.com/google/closure-compiler.git"

  depends_on :ant => :build

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/compiler.jar", "closure-compiler"
  end
end
