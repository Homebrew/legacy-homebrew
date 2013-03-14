require 'formula'

class ClosureCompiler < Formula
  homepage 'http://code.google.com/p/closure-compiler/'
  url 'https://code.google.com/p/closure-compiler/', :using => :git, :tag => 'v20130227'
  version '20130227'

  head 'https://code.google.com/p/closure-compiler/', :using => :git

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir['*']
    bin.write_jar_script libexec/'build/compiler.jar', 'closure-compiler'
  end
end
