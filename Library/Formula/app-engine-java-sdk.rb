require "formula"

class AppEngineJavaSdk < Formula
  homepage "https://developers.google.com/appengine/docs/java/gettingstarted/introduction"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.19.zip"
  sha256 "22a761ea50af1d1a0e1f698cc3fa91765391902a633ca886ea1a6426c3ae1ccb"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
