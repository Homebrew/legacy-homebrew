require 'formula'

class JsTestDriver < Formula
  homepage 'http://code.google.com/p/js-test-driver/'
  url 'https://js-test-driver.googlecode.com/files/JsTestDriver-1.3.5.jar'
  sha1 '7a29ace71b9d5a82f5f0abe0ea22b73d7fd07826'

  def install
    libexec.install 'JsTestDriver-1.3.5.jar'
    bin.write_jar_script libexec/'JsTestDriver-1.3.5.jar', 'js-test-driver'
  end
end
