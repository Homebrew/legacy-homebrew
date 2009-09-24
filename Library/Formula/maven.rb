require 'brewkit'

class Maven <Formula
  @url='http://apache.mirrors.timporter.net/maven/binaries/apache-maven-2.2.1-bin.tar.gz'
  @version="2.2.1"
  @homepage='http://maven.apache.org/'
  @md5='3f829ed854cbacdaca8f809e4954c916'

  def install
    prefix.install %w[bin conf boot lib]
    FileUtils.rm_f Dir["#{bin}/*.bat"]
  end
end
