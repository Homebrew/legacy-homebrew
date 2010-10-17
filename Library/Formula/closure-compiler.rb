require 'formula'

class ClosureCompiler <Formula
  url 'http://closure-compiler.googlecode.com/files/compiler-20100917.tar.gz'
  homepage 'http://code.google.com/p/closure-compiler/'
  md5 '581e7d667103d8bee08ff8adf7e39e56'

  def install
    libexec.install "compiler.jar"
    (bin+'closure').write <<-EOS.undent
      #!/bin/bash
      java -jar #{libexec}/compiler.jar $@
    EOS
  end
end
