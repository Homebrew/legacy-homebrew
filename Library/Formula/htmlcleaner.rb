class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.15/htmlcleaner-2.15-src.zip"
  sha256 "ef53982c3bc40c48931f4ea46e3dfa615b525d91afc1bfb3ed1727eca7168403"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "0c76567a694dc7c7237c7c8eab44c2267c37162ffb69b6bbd63634f0abf55f96" => :el_capitan
    sha256 "57fee94170c021c20f8c3d055ae23857eee9069a3f16d87bd486c02181aba0c0" => :yosemite
    sha256 "064d666d3c634989483e306a75671db3d8871426c4ce3d85ef0b2b8179e279f4" => :mavericks
  end

  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "clean", "package"
    libexec.install Dir["target/htmlcleaner-*-SNAPSHOT.jar"]
    bin.write_jar_script Dir["#{libexec}/htmlcleaner-*-SNAPSHOT.jar"].first, "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
