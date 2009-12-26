require 'formula'

class Groovy <Formula
  @url='http://dist.groovy.codehaus.org/distributions/groovy-binary-1.7.0.zip'
  @homepage='http://groovy.codehaus.org/'
  @version='1.7.0'
  @sha256='7f08ce19c757ddf8b14f5dcf909048719c82348584aa707bbe0a65a9dd9c6afc'

  def install
    prefix.install %w[bin conf lib]
    FileUtils.rm_f Dir["#{bin}/*.bat"]
  end
end
