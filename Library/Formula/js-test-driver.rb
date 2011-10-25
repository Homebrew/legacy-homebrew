require 'formula'

class JsTestDriver < Formula
  url 'http://js-test-driver.googlecode.com/files/JsTestDriver-1.3.2.jar'
  homepage 'http://code.google.com/p/js-test-driver/'
  md5 'c3e65522aac33c2116be918c80cf303c'

  def install
    libexec.install "JsTestDriver-1.3.2.jar"
    (bin+'js-test-driver').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/JsTestDriver-1.3.2.jar" $@
    EOS
  end
end
