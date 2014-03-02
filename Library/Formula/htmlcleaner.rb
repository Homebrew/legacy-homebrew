require 'formula'

class Htmlcleaner < Formula
  homepage 'http://htmlcleaner.sourceforge.net/index.php'
  url 'https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.7/htmlcleaner-2.7.zip'
  sha1 'dc9032cbce6dfa2abd2eae060aa146a0d6af9d9f'

  def install
    libexec.install "htmlcleaner-#{version}.jar"
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"

    output = `#{bin}/htmlcleaner src=#{path}`
    assert output.include?("</html>")
    assert_equal 0, $?.exitstatus
  end
end
