require 'formula'

class ClosureCompiler < Formula
  url 'http://closure-compiler.googlecode.com/files/compiler-20120305.tar.gz'
  homepage 'http://code.google.com/p/closure-compiler/'
  md5 '513344df6f18bfa00b17f034cabf897d'

  def install
    libexec.install "compiler.jar"
    (bin+'closure').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/compiler.jar" "$@"
    EOS
  end
end
