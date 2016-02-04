class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.16/htmlcleaner-2.16-src.zip"
  sha256 "8b9066ebdaff85b15b3cb29208549227ca49351b4bd01779ea8cb3de6f4aac7e"

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
    libexec.install Dir["target/htmlcleaner-*.jar"]
    bin.write_jar_script "#{libexec}/htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
