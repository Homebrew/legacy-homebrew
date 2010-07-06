require 'formula'

class SpringRoo <Formula
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.0.2.RELEASE.zip'
  version '1.0.2'
  homepage 'http://www.springsource.org/roo'
  md5 '31d4444700311b14388a29139f4ea9bc'

  def install
    inreplace 'bin/roo.sh', '$ROO_HOME/lib', '$ROO_HOME/java/lib'

    FileUtils.rm_f Dir["bin/*.bat"]
    prefix.install %w[bin dist docs legal]
    (prefix+'java').install 'lib'
  end
end
