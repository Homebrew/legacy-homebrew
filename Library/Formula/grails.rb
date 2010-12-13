require 'formula'

class Grails <Formula
  url 'http://dist.codehaus.org/grails/grails-1.3.5.zip'
  homepage 'http://grails.org'
  md5 'c1323fb99b6d173754e9034f3971e2ca'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install Dir['*']
  end
end