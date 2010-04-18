require 'formula'

class Grails <Formula
  url 'http://dist.codehaus.org/grails/grails-1.2.2.zip'
  homepage 'http://grails.org'
  md5 'dcfe25c2425ec86e47dea7722b44c744'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install Dir['*']
  end
end
