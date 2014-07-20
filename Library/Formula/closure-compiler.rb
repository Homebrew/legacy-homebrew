require 'formula'

class ClosureCompiler < Formula
  homepage 'https://github.com/google/closure-compiler'
  url 'https://github.com/google/closure-compiler/archive/closure-compiler-maven-v20140407.tar.gz'
  sha1 '80eba20da24f2d7b9f9f45d97ca49deb2668ef03'

  head 'https://github.com/google/closure-compiler.git'

  depends_on :ant => :build

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir['*']
    bin.write_jar_script libexec/'build/compiler.jar', 'closure-compiler'
  end
end
