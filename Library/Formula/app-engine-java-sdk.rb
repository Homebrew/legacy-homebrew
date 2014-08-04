require "formula"

class AppEngineJavaSdk < Formula
  homepage "https://developers.google.com/appengine/docs/java/gettingstarted/introduction"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.8.zip"
  sha1 "d217659f3da668cf1af514f8fe5b26e6407d0b9c"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
