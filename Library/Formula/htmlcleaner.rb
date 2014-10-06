require "formula"

class Htmlcleaner < Formula
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.9/htmlcleaner-2.9.zip"
  sha1 "62444799192574d47d3264a48518237685e05667"

  def install
    libexec.install "htmlcleaner-#{version}.jar"
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert shell_output("#{bin}/htmlcleaner src=#{path}").include?("</html>")
  end
end
