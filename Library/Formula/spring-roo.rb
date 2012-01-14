require 'formula'

class SpringRoo < Formula
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.2.0.RELEASE.zip'
  version '1.2.0'
  homepage 'http://www.springsource.org/spring-roo'
  md5 'f48181fa96f984fc4275f57860cc4cee'

  def install
    rm Dir["bin/*.bat"]
    File.rename "bin/roo.sh", "bin/roo"
    prefix.install %w[annotations bin bundle conf docs legal samples]
  end
end
