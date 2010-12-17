require 'formula'

class SpringRoo <Formula
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.1.0.RELEASE.zip'
  version '1.1.0'
  homepage 'http://www.springsource.org/roo'
  md5 '691247051da50df9b8dbd6b91ccd11a7'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[annotations bin bundle conf docs legal]
  end
end
