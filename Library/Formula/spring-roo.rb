require 'formula'

class SpringRoo <Formula
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.1.1.RELEASE.zip'
  version '1.1.1'
  homepage 'http://www.springsource.org/roo'
  md5 '8ce9ae41d2249602f1351203cf58ae97'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[annotations bin bundle conf docs legal samples]
  end
end
