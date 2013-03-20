require 'formula'

class SpringRoo < Formula
  homepage 'http://www.springsource.org/spring-roo'
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.2.3.RELEASE.zip'
  sha1 '5980d587647ca651f90ed67ebaf0ab67212f7ee1'
  version '1.2.3'

  def install
    rm Dir["bin/*.bat"]
    File.rename "bin/roo.sh", "bin/roo"
    prefix.install %w[annotations bin bundle conf docs legal samples]
  end
end
