require 'formula'

class Htmlcompressor < Formula
  url 'http://htmlcompressor.googlecode.com/files/htmlcompressor-1.5.2.jar'
  homepage 'http://code.google.com/p/htmlcompressor/'
  md5 '91575c89c83d0563dcf2aad409e4748f'

  def install
    libexec.install "htmlcompressor-1.5.2.jar"
    (bin+'htmlcompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/htmlcompressor-1.5.2.jar" $@
    EOS
  end
end
