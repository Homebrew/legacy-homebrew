class Duck < Formula
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-4.6.2.16366.tar.gz"
  sha1 "135f7ca7315fd478607e590eaa2df43418d85e0d"
  head "https://svn.cyberduck.io/trunk/"

  depends_on :java => [:build, "1.7"]
  depends_on :xcode => :build
  depends_on "ant" => :build

  def install
    system "ant", "-Dbuild.compile.target=1.7", "-Drevision=#{version.to_str[/(\d\.\d(\.\d)?)\.(\d+)/, 3]}", "cli"
    libexec.install Dir["build/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    filename = (testpath/"test")
    system "#{bin}/duck", "--download", stable.url, filename
    filename.verify_checksum stable.checksum
  end
end
