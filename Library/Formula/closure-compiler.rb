require 'formula'

class Java7 < Requirement
  fatal true

  def satisfied?
    `java -version`.split("\n")[0] =~ /"1\.7/
  end

  def message
    "Java 7 is required."
  end
end

class ClosureCompiler < Formula
  homepage 'http://code.google.com/p/closure-compiler/'
  url 'https://code.google.com/p/closure-compiler/', :using => :git, :tag => 'v20140303'

  head 'https://code.google.com/p/closure-compiler/', :using => :git

  depends_on :ant
  depends_on Java7

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir['*']
    bin.write_jar_script libexec/'build/compiler.jar', 'closure-compiler'
  end
end
