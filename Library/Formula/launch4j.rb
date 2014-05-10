require 'formula'

class Launch4j < Formula
  homepage 'http://launch4j.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.3/launch4j-3.3-macosx-x86-10.8.tgz'
  sha1 '512e424d9e3eb697d70fda02ca6a204e246838b2'
  version '3.3'

  def install
    libexec.install Dir['*'] - ['src', 'web']
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end
end
