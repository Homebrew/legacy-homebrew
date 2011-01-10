require 'formula'

class Grails <Formula
  url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-1.3.6.zip'
  homepage 'http://grails.org'
  md5 '56fc68a118ca9c65e2c4391c3226a120'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install Dir['*']
  end
end