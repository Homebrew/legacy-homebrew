class JsTestDriver < Formula
  desc "JavaScript test runner"
  homepage "https://code.google.com/p/js-test-driver/"
  url "https://js-test-driver.googlecode.com/files/JsTestDriver-1.3.5.jar"
  sha256 "78c0ff60a76bea38db0fa6f9c9f8e003d1bfd07517f44c3879f484abfbe87a68"

  def install
    libexec.install "JsTestDriver-#{version}.jar"
    bin.write_jar_script libexec/"JsTestDriver-#{version}.jar", "js-test-driver"
  end
end
