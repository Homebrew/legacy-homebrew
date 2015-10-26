class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://www.eclipse.org/jetty/documentation/9.2.2.v20140723/runner.html"
  url "http://central.maven.org/maven2/org/eclipse/jetty/jetty-runner/9.2.2.v20140723/jetty-runner-9.2.2.v20140723.jar"
  version "9.2.2.v20140723"
  sha256 "6b7ba03e23f65f86f946e19860da10afb326f13c74abfb84718db07280201e5c"

  bottle :unneeded

  def install
    libexec.install Dir["*"]

    bin.mkpath
    bin.write_jar_script libexec/"jetty-runner-#{version}.jar", "jetty-runner"
  end
end
