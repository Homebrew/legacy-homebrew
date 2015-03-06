class Duck < Formula
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-4.6.5.17000.tar.gz"
  sha1 "bd26842b09bf41f86791a7172b93ac88f029b354"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha1 "c0439df03eaf84f6b8a446b5207963e4ca35609b" => :yosemite
    sha1 "b8e8a45673394a7034e63e5514eac65a122bdc16" => :mavericks
    sha1 "be719af049e6b39490554f8e1ba916c2b7de77ea" => :mountain_lion
  end

  depends_on :java => ["1.7", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build

  def install
    revision = version.to_s.rpartition(".").last
    system "ant", "-Dbuild.compile.target=1.7", "-Drevision=#{revision}", "cli"
    libexec.install Dir["build/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    filename = (testpath/"test")
    system "#{bin}/duck", "--download", stable.url, filename
    filename.verify_checksum stable.checksum
  end
end
