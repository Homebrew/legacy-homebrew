require 'formula'

class Htmlcompressor < Formula
  url 'http://htmlcompressor.googlecode.com/files/htmlcompressor-1.3.1.jar'
  homepage 'http://code.google.com/p/htmlcompressor/'
  md5 'e0a1fde8210d3197e87bffa6e0d9ee0d'

  def install
    libexec.install "htmlcompressor-1.3.1.jar"
    (bin+'htmlcompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/htmlcompressor-1.3.1.jar" $@
    EOS
  end
end
