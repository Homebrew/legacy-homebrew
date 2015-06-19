require "formula"

class AppEngineJavaSdk < Formula
  desc "Google App Engine for Java"
  homepage "https://developers.google.com/appengine/docs/java/gettingstarted/introduction"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.21.zip"
  sha256 "1c1a107330ab45945b4ca3e787dd83be23d0aaf1d177ca30857208d5aec8ac96"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
