require 'formula'

class Grails <Formula
  url 'http://dist.codehaus.org/grails/grails-1.3.0.zip'
  homepage 'http://grails.org'
  md5 '0117efe1cbff4e0bb4fe3eb05e37a0c0'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install Dir['*']
  end
end
