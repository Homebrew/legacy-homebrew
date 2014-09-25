require "formula"

class ClosureCompiler < Formula
  homepage "https://github.com/google/closure-compiler"
  url "https://github.com/google/closure-compiler/archive/maven-release-v20140814.tar.gz"
  sha1 "d783183bd91e2661aa8cd1a8c35c210935e23e15"

  head "https://github.com/google/closure-compiler.git"

  depends_on :ant => :build

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/compiler.jar", "closure-compiler"
  end
end
