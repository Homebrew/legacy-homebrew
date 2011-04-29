require 'formula'

class Htmlcompressor < Formula
  url 'http://htmlcompressor.googlecode.com/files/htmlcompressor-1.3.jar'
  homepage 'http://code.google.com/p/htmlcompressor/'
  md5 '68296830cb99e4348284ea88602ed06b'

  def install
    libexec.install "htmlcompressor-1.3.jar"
    (bin+'htmlcompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/htmlcompressor-1.3.jar" $@
    EOS
  end
end
