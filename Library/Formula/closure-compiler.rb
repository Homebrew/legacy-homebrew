require 'formula'

class ClosureCompiler < Formula
  homepage 'http://code.google.com/p/closure-compiler/'
  url 'https://code.google.com/p/closure-compiler/', :using => :git, :tag => 'v20140303'

  head 'https://code.google.com/p/closure-compiler/', :using => :git

  depends_on :ant

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir['*']
    bin.write_jar_script libexec/'build/compiler.jar', 'closure-compiler'
  end
end
