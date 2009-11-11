require 'formula'

class Groovy <Formula
  @url='http://dist.groovy.codehaus.org/distributions/groovy-binary-1.6.5.zip'
  @homepage='http://groovy.codehaus.org/'
  @version='1.6.5'
  @sha256='db3d4c08ad76392ae94eba830e8c9072fda9e5774c9e7d220c90d0f91a5d7aaf'

  def install
    prefix.install %w[bin conf lib]
    FileUtils.rm_f Dir["#{bin}/*.bat"]
  end
end
