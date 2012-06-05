require 'formula'

class ClosureCompiler < Formula
  homepage 'http://code.google.com/p/closure-compiler/'
  url 'http://closure-compiler.googlecode.com/files/compiler-20120430.tar.gz'
  sha1 '8adabd3a4307a4168cb050cdcc588e82060d15d3'

  def install
    libexec.install "compiler.jar"
    (bin+'closure').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/compiler.jar" "$@"
    EOS
  end
end
