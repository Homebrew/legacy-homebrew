class TomcatRunner < Formula
  desc "Run Tomcat without an installed distribution"
  homepage "https://github.com/jsimone/webapp-runner"
  url "https://repo1.maven.org/maven2/com/github/jsimone/webapp-runner/8.0.24.0/webapp-runner-8.0.24.0.jar"
  sha256 "906ca6902dd481ad1b7e0c5287daefc81e111b70b6f4ec37c1bf03b48e56099d"

  def install
    libexec.install Dir["*"]

    bin.write_jar_script libexec/"webapp-runner-#{version}.jar", "tomcat-runner"
  end

  test do
    usage = shell_output("#{bin}/tomcat-runner --help", 1)
    assert_match /--path/, usage
    assert_match /--port/, usage
  end
end
