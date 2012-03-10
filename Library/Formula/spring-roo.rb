require 'formula'

class SpringRoo < Formula
  homepage 'http://www.springsource.org/spring-roo'
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.2.1.RELEASE.zip'
  sha1 'aa2ffb42d9fd1e5456767635974eef60e6a3001b'
  version '1.2.1'

  def install
    rm Dir["bin/*.bat"]
    File.rename "bin/roo.sh", "bin/roo"
    prefix.install %w[annotations bin bundle conf legal samples]
  end
end
