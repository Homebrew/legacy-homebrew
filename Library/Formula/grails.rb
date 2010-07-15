require 'formula'

class Grails <Formula
  url 'http://dist.codehaus.org/grails/grails-1.3.3.zip'
  homepage 'http://grails.org'
  md5 '2573fcd2a50d9f2f4b07450638c56b7c'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install Dir['*']
  end
end
