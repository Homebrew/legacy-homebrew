require "formula"

class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.10/htmlcleaner-2.10.zip"
  sha1 "dddeeece559b3834c2699f2dba72393de2b53186"

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
