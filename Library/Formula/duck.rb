class Duck < Formula
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-4.6.5.16970.tar.gz"
  sha1 "7569f8511e9154b2fa48d76348c43e336972cc88"
  head "https://svn.cyberduck.io/trunk/"

  depends_on :java => [:build, "1.7"]
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
