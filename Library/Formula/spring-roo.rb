require 'formula'

class SpringRoo <Formula
  version '1.0.2'
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-#{version}.RELEASE.zip'
  homepage 'http://www.springsource.org/roo'
  md5 '31d4444700311b14388a29139f4ea9bc'

  def install
    prefix.install %w[bin dist docs legal lib]
    FileUtils.rm_f Dir["#{bin}/*.bat"]
  end
end
