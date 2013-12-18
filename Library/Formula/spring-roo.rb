require 'formula'

class SpringRoo < Formula
  homepage 'http://www.springsource.org/spring-roo'
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.2.4.RELEASE.zip'
  sha1 '203ee7bf35c49f0b53a5e090bf041594ff54ec73'
  version '1.2.4'

  def install
    rm Dir["bin/*.bat"]
    File.rename "bin/roo.sh", "bin/roo"
    prefix.install %w[annotations bin bundle conf docs legal samples]
  end
end
