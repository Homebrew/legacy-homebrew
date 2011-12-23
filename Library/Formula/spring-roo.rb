require 'formula'

class SpringRoo < Formula
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.2.0.RELEASE.zip'
  version '1.2.0'
  homepage 'http://www.springsource.org/spring-roo'
  sha1 '3fa1fccd9e69d3b5c83f5bb70f1f3d852178d400'

  def install
    rm Dir["bin/*.bat"]
    File.rename "bin/roo.sh", "bin/roo"
    prefix.install %w[annotations bin bundle conf docs legal samples]
  end
end
