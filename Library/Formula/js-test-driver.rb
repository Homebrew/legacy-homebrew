require 'formula'

class JsTestDriver < Formula
  homepage 'http://code.google.com/p/js-test-driver/'
  url 'http://js-test-driver.googlecode.com/files/JsTestDriver-1.3.4-a.jar'
  version '1.3.4-a'
  md5 'cc3d62d817d0887c7f78e14db81d8c24'

  def install
    libexec.install "JsTestDriver-1.3.4-a.jar"
    (bin+'js-test-driver').write <<-EOS.undent
      #!/bin/bash
      java -jar "#{libexec}/JsTestDriver-1.3.4-a.jar" "$@"
    EOS
  end
end
