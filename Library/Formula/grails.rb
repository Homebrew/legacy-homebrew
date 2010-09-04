require 'formula'

class Grails <Formula
  url 'http://dist.codehaus.org/grails/grails-1.3.4.zip'
  homepage 'http://grails.org'
  md5 'd4c968cf4869cf7afdaae0b17c85beba'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install Dir['*']
  end
end