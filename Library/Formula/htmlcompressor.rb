require 'formula'

class Htmlcompressor <Formula
  url 'http://htmlcompressor.googlecode.com/files/htmlcompressor-0.9.4.jar'
  homepage 'http://code.google.com/p/htmlcompressor/'
  md5 '6b6a68a048ce52b4fd567e1beeb2cfb6'

  def install
    libexec.install "htmlcompressor-0.9.4.jar"
    (bin+'htmlcompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/htmlcompressor-0.9.4.jar" $@
    EOS
  end
end
