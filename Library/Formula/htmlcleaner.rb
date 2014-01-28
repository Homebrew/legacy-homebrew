require 'formula'

class Htmlcleaner < Formula
  homepage 'http://htmlcleaner.sourceforge.net/index.php'
  url 'http://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.7/htmlcleaner-2.7.zip'
  sha1 'dc9032cbce6dfa2abd2eae060aa146a0d6af9d9f'

  def install
    libexec.install "htmlcleaner-#{version}.jar"
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner"
  end
end
