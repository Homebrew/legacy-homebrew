require 'formula'

class ClosureCompiler < Formula
  homepage 'http://code.google.com/p/closure-compiler/'
  url 'svn+http://closure-compiler.googlecode.com/svn/trunk/', :revision => '1918'
  version 'r1918'

  head 'svn+http://closure-compiler.googlecode.com/svn/trunk/'

  def install
    system "ant", "clean"
    system "ant"

    libexec.install Dir['*']

    (bin+'closure-compiler').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/build/compiler.jar" "$@"
    EOS
  end
end
