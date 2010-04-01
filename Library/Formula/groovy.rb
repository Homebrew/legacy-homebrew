require 'formula'

class Groovy <Formula
  url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-1.7.1.zip'
  md5 '65f522de612ca56e815992fffbf10d12'
  homepage 'http://groovy.codehaus.org/'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[bin conf lib]
  end
end
