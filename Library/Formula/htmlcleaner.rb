require 'formula'

class Htmlcleaner < Formula
  homepage 'http://htmlcleaner.sourceforge.net/index.php'
  url 'http://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.6.1/htmlcleaner-2.6.1.zip'
  sha1 '4c5d2049c7048dc6632a17ec15e21ab0fcf510b9'

  def install
    libexec.install "htmlcleaner-#{version}.jar"
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner"
  end
end
