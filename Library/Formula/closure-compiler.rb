require 'formula'

class ClosureCompiler < Formula
  homepage 'http://code.google.com/p/closure-compiler/'
  # switched to archive over tags from git
  url 'https://closure-compiler.googlecode.com/files/compiler-20130227.tar.gz'
  sha1 '0becbcb3b4f23162f4df50d2996e1a0765f75b75'
  version '20130227'

  head 'https://code.google.com/p/closure-compiler/', :using => :git

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir['*']
    bin.write_jar_script libexec/'build/compiler.jar', 'closure-compiler'
  end
end