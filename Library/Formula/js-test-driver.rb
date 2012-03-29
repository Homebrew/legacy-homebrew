require 'formula'

class JsTestDriver < Formula
  homepage 'http://code.google.com/p/js-test-driver/'
  url 'https://js-test-driver.googlecode.com/files/JsTestDriver-1.3.4.b.jar'
  md5 '384a95a0504749f9ea34ba52e0a546b8'
  sha1 'ce036e7c0973ff0588a52f0d3730b5c938404ed1'

  def install
    libexec.install "JsTestDriver-1.3.4.b.jar"
    (bin+'js-test-driver').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/JsTestDriver-1.3.4.b.jar" "$@"
    EOS
  end
end
