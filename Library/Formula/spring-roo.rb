class SpringRoo < Formula
  desc "Rapid application development tool for Java developers"
  homepage "http://www.springsource.org/spring-roo"
  url "https://s3.amazonaws.com/spring-roo-repository.springsource.org/release/ROO/spring-roo-1.3.2.RELEASE.zip"
  version "1.3.2"
  sha256 "535fb618fe2b9534f0a8bf7003750bb3835ec93ef8a48b05a3511e2adc8ffe9c"

  bottle :unneeded

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    mv "#{libexec}/bin/roo.sh", "#{libexec}/bin/roo"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
