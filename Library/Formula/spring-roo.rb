require 'formula'

class SpringRoo < Formula
  homepage 'http://www.springsource.org/spring-roo'
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.2.5.RELEASE.zip'
  sha1 'a1b5d5d5081c7e74d20ef65cdf0c55cc744e0850'
  version '1.2.5'

  def install
    rm Dir["bin/*.bat"]
    File.rename "bin/roo.sh", "bin/roo"
    prefix.install %w[annotations bin bundle conf docs legal samples]
  end
end
