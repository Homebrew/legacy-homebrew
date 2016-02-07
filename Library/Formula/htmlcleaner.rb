class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.16/htmlcleaner-2.16-src.zip"
  sha256 "8b9066ebdaff85b15b3cb29208549227ca49351b4bd01779ea8cb3de6f4aac7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bf9827d2819dc87b93d86b08bc77c04c418483a7cb834853524174592f9f672" => :el_capitan
    sha256 "015a92188a5dc625ee57a5f2250c8c9029cfa770763d511ad9494964a6ce87a4" => :yosemite
    sha256 "334a1504f936068186b106661eb95791f7b80aa2f05382ca092c6f4c66f8756b" => :mavericks
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
