class SonarRunner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "http://docs.sonarqube.org/display/SONAR/Analyzing+with+SonarQube+Scanner"
  url "https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.5.zip"
  sha256 "e2ec5f4b73aa7911f10518e304db3af0146a4347b8d06fc1d4a36b8baec0d8cc"
  head "https://github.com/SonarSource/sonar-runner.git"

  bottle :unneeded

  def install
    # Remove windows files
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/sonar-runner"
  end

  def caveats; <<-EOS.undent
      If this is your first install, you should adjust the default configuration:
        #{libexec}/conf/sonar-runner.properties

      after that you should also add a new enviroment variable:
        SONAR_RUNNER_HOME=#{libexec}
      EOS
  end

  test do
    system "#{bin}/sonar-runner", "-h"
  end
end
