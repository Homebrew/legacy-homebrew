require 'formula'

class Grails <Formula
  url 'http://dist.codehaus.org/grails/grails-1.3.1.zip'
  homepage 'http://grails.org'
  md5 'eae157394eeaa704015756a7613eae50'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install Dir['*']
  end
end
