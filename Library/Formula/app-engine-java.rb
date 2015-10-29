class AppEngineJava < Formula
  desc "Google App Engine for Java"
  homepage "https://cloud.google.com/appengine/docs/java/gettingstarted/introduction"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.27.zip"
  sha256 "069fc498bd292af01577f941f1f7d950e0bfe427f83099a1e381f7382500f0b6"

  bottle :unneeded

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
