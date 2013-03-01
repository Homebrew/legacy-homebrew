require 'formula'

class ClosureCompiler < Formula
  homepage 'http://code.google.com/p/closure-compiler/'
  # Use an SVN download to get the externals as well
  url 'svn+http://closure-compiler.googlecode.com/svn/trunk/', :revision => '2388'
  version '20121212'

  head 'svn+http://closure-compiler.googlecode.com/svn/trunk/'

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir['*']
    bin.write_jar_script libexec/'build/compiler.jar', 'closure-compiler'
  end
end
