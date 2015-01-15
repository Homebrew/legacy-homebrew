class Duck < Formula
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-4.6.2.16480.tar.gz"
  sha1 "6e38a90c97bbe7d577791a4fbdd07872e8457101"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha1 "05353941783e34f1931b0cdd78a89f245d8daf33" => :yosemite
    sha1 "a2120b7b4b7ae15f9b941c24bb9d4f7c36392e74" => :mavericks
    sha1 "fb6e8e20d702cf3d9808e758328cd7ebc8830283" => :mountain_lion
  end

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
