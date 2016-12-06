require 'formula'

class Maven <Formula
  url 'http://www.apache.org/dist/maven/binaries/apache-maven-2.2.1-bin.tar.gz'
  homepage 'http://maven.apache.org/'
  md5 '3f829ed854cbacdaca8f809e4954c916'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[bin conf boot lib]
  end
end
