class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.15/htmlcleaner-2.15-src.zip"
  sha256 "ef53982c3bc40c48931f4ea46e3dfa615b525d91afc1bfb3ed1727eca7168403"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eacfd83d285f550518600900b4aa331325b9180e8af6be765d5b1ec05b75d24" => :el_capitan
    sha256 "1a646a6ed7834215f9a3fc14227a345f55039a9ef6f82cc39afe2ff51b6f3d82" => :yosemite
    sha256 "332c0488ab1cb94a1194eb860963bf524b865ee99e6c7d98d536e8d12348b5bd" => :mavericks
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
