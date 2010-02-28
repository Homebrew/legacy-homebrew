require 'formula'

class Grails <Formula
  url 'http://dist.codehaus.org/grails/grails-1.2.1.zip'
  homepage 'http://grails.org'
  version '1.2.1'
  md5 'd82553956c8249906d247172cfea9e55'

  def install
    prefix.install Dir['*']
    FileUtils.rm_f Dir["#{bin}/*.bat"]
  end
end
