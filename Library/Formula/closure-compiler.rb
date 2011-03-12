require 'formula'

class ClosureCompiler <Formula
  url 'http://closure-compiler.googlecode.com/files/compiler-20110119.tar.gz'
  homepage 'http://code.google.com/p/closure-compiler/'
  md5 '1e88d14026e63051df2aa3a89c9efcf3'

  def install
    libexec.install "compiler.jar"
    (bin+'closure').write <<-EOS.undent
      #!/bin/bash
      java -jar #{libexec}/compiler.jar $@
    EOS
  end
end
