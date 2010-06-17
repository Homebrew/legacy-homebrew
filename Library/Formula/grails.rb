require 'formula'

class Grails <Formula
  url 'http://dist.codehaus.org/grails/grails-1.3.2.zip'
  homepage 'http://grails.org'
  md5 '59586a39bf0b96e6c0689a3cffab9813'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install Dir['*']
  end
end
