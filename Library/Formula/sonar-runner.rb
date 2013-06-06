require 'formula'

class SonarRunner < Formula
  homepage 'http://docs.codehaus.org/display/SONAR/Installing+and+Configuring+Sonar+Runner'
  url 'http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.1/sonar-runner-dist-2.1.zip'
  sha1 '98790f6c8c49fc78419fa2e81f9cc42d6fff510c'

  def install
    # Remove windows files
    rm_rf Dir['bin/*.bat']
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/sonar-runner'
  end

  def caveats; <<-EOS.undent
      If this is your first install, you should adjust its default configuration:
        #{libexec}/conf/sonar-runner.properties

      after that you should also add a new enviroment variable:
        SONAR_RUNNER_HOME=#{libexec}
      EOS
  end

  def test
    system "#{bin}/sonar-runner", "-h"
  end
end
