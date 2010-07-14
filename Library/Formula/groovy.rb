require 'formula'

class Groovy <Formula
  url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-1.7.3.zip'
  md5 '4ae4c7c2620c0610b1fe2aa24a6776e2'
  homepage 'http://groovy.codehaus.org/'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[bin conf lib]
  end
end
