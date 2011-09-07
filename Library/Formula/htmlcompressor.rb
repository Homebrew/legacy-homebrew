require 'formula'

class Htmlcompressor < Formula
  url 'http://htmlcompressor.googlecode.com/files/htmlcompressor-1.4.2.jar'
  homepage 'http://code.google.com/p/htmlcompressor/'
  md5 '2afe7aba064c619a761541ab466cca28'

  def install
    libexec.install "htmlcompressor-1.4.2.jar"
    (bin+'htmlcompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/htmlcompressor-1.4.2.jar" $@
    EOS
  end
end
