require "formula"

class AppEngineJavaSdk < Formula
  homepage "https://developers.google.com/appengine/docs/java/gettingstarted/introduction"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.18.zip"
  sha1 "7f554498a7320192186fc8c3e4ad3f1aaab4d6dd"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
