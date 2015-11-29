class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.15/htmlcleaner-2.15-src.zip"
  sha256 "ef53982c3bc40c48931f4ea46e3dfa615b525d91afc1bfb3ed1727eca7168403"

  depends_on "maven" => :build

  def install
    system "mvn", "clean", "package", "-Duser.home=#{buildpath}"
    libexec.install Dir["target/htmlcleaner-*-SNAPSHOT.jar"]
    bin.write_jar_script Dir["#{libexec}/htmlcleaner-*-SNAPSHOT.jar"].first, "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
