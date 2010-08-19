require 'formula'

class Groovy <Formula
  url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-1.7.4.zip'
  md5 '4eb5576fd6bd53d32a93136c977278fd'
  homepage 'http://groovy.codehaus.org/'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[bin conf lib]
  end
end
