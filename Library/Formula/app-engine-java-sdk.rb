require "formula"

class AppEngineJavaSdk < Formula
  homepage "https://developers.google.com/appengine/docs/java/gettingstarted/introduction"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.13.zip"
  sha1 "5fea5d7823416479f3ba08f8bca9363389637566"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
