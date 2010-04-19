require 'formula'

class Groovy <Formula
  url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-1.7.2.zip'
  md5 'e45acf74926681fa0e335d19a8e7dbd2'
  homepage 'http://groovy.codehaus.org/'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[bin conf lib]
  end
end
