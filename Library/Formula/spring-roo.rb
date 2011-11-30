require 'formula'

class SpringRoo < Formula
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.1.5.RELEASE.zip'
  version '1.1.5'
  homepage 'http://www.springsource.org/spring-roo'
  md5 '926c08e39ab8cefb935027ccae6d2285'

  def install
    rm Dir["bin/*.bat"]
    File.rename "bin/roo.sh", "bin/roo"
    prefix.install %w[annotations bin bundle conf docs legal samples]
  end
end
