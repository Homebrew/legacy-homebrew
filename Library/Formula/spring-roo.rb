require 'formula'

class SpringRoo < Formula
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.1.2.RELEASE.zip'
  version '1.1.2'
  homepage 'http://www.springsource.org/roo'
  md5 '41ee8991009ecd1f7ce16b9adb7aaadb'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[annotations bin bundle conf docs legal samples]
  end
end
