class SpringRoo < Formula
  desc "Rapid application development tool for Java developers"
  homepage "http://www.springsource.org/spring-roo"
  url "https://s3.amazonaws.com/spring-roo-repository.springsource.org/release/ROO/spring-roo-1.3.1.RELEASE.zip"
  version "1.3.1"
  sha256 "50be1c39ee56a0f2fba0109ed9326fbab018e08f9377dca3202fc8f8a4b5a784"

  bottle :unneeded

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    mv "#{libexec}/bin/roo.sh", "#{libexec}/bin/roo"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
