class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://trac.cyberduck.io/changeset/20017/tags/release-4-8-4/cli/src?old_path=%2F&format=zip"
  sha256 "0b349ea16a6ca18614d6e3b49a89fc35fdf63c894cf21c02b828281d191add51"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "357282a2d6092927a8dd133e9868646dffab55b339376280b8476d19cf7db6b8" => :el_capitan
    sha256 "fb45a7ae70bbf69a247563591deb6b5f8a305f4a2bf073bd216c4567cd6e3864" => :yosemite
    sha256 "6aaab98af32f261163510703ea45f15aeedc38fb81af648952a294ddf96c438a" => :mavericks
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build

  def install
    revision = version.to_s.rpartition(".").last
    system "ant", "-Dbuild.compile.target=1.8", "-Drevision=#{revision}", "cli"
    libexec.install Dir["build/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["wget"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["wget"].stable.checksum
  end
end
