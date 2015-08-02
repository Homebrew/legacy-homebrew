require "formula"

class SpringRoo < Formula
  desc "Rapid application development tool for Java developers"
  homepage "http://www.springsource.org/spring-roo"
  url "https://s3.amazonaws.com/spring-roo-repository.springsource.org/release/ROO/spring-roo-1.3.1.RELEASE.zip"
  sha1 "31c9d57c4a8ed38dc059bffcde192886e96e25ea"
  version "1.3.1"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    File.rename "#{libexec}/bin/roo.sh", "#{libexec}/bin/roo"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
