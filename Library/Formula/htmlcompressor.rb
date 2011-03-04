require 'formula'

class Htmlcompressor <Formula
  url 'http://htmlcompressor.googlecode.com/files/htmlcompressor-0.9.9.jar'
  homepage 'http://code.google.com/p/htmlcompressor/'
  md5 'cbfb5ec29d6f2c50b7aea28de8bc1227'

  def install
    libexec.install "htmlcompressor-0.9.9.jar"
    (bin+'htmlcompressor').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/htmlcompressor-0.9.9.jar" $@
    EOS
  end
end
