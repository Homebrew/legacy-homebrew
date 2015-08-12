class AppEngineJava < Formula
  desc "Google App Engine for Java"
  homepage "https://cloud.google.com/appengine/docs/java/gettingstarted/introduction"
  url "https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.32.zip"
  sha256 "1e757250acb1ecb61a09854bd07ee82a781cdb1fa76c44ed056b4de73a4cff79"

  bottle :unneeded

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
