require 'formula'

class JsTestDriver < Formula
  url 'http://js-test-driver.googlecode.com/files/JsTestDriver-1.3.3d.jar'
  homepage 'http://code.google.com/p/js-test-driver/'
  md5 '458afde3afdefb7dfa64964992c2471c'
  version '1.3.3d'

  def install
    libexec.install "JsTestDriver-1.3.3d.jar"
    (bin+'js-test-driver').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/JsTestDriver-1.3.3d.jar" $@
    EOS
  end
end
