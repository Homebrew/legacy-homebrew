require 'formula'

class Htmlcleaner < Formula
  homepage 'http://htmlcleaner.sourceforge.net/index.php'
  url 'https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.8/htmlcleaner-2.8.zip'
  sha1 'e4cbfebb306fc0baa95205ba91e452c961eebf85'

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
