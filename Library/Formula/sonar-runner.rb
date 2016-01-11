class SonarRunner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "http://docs.sonarqube.org/display/SONAR/Installing+and+Configuring+SonarQube+Runner"
  url "https://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip"
  sha256 "f794545e23092c8b56d64d58ff571b2599480150b3fc41173b3761d634a16d48"
  head "https://github.com/SonarSource/sonar-runner.git"

  bottle :unneeded

  def install
    # Remove windows files
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/sonar-runner"
  end

  def caveats; <<-EOS.undent
      If this is your first install, you should adjust its default configuration:
        #{libexec}/conf/sonar-runner.properties

      after that you should also add a new enviroment variable:
        SONAR_RUNNER_HOME=#{libexec}
      EOS
  end

  test do
    system "#{bin}/sonar-runner", "-h"
  end
end
