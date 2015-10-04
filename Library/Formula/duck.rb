class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-4.7.2.18007.tar.gz"
  sha256 "2b30071ef58aed42805724f318b1e3f013749cc534e54265ee305dfc2ec86d69"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "7158c51d7841954199a5cb1ee5cec88a99ab99b3a50943546a63634e52073610" => :el_capitan
    sha256 "1cf4fd37421f57153d17789025ad2b95909e009e8507226d3e33457474f47121" => :yosemite
    sha256 "0be31b18470ab4fe70bedbaa730ca1de5204355c2ddd3d114ad4763afdf611f0" => :mavericks
    sha256 "b2a3135eee96ba4ab7d66b049f16467e61c6cb69a6bbfd98b32c46ef570be9f0" => :mountain_lion
  end

  depends_on :java => ["1.7+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build

  def install
    revision = version.to_s.rpartition(".").last
    system "ant", "-Dbuild.compile.target=1.7", "-Drevision=#{revision}", "cli"
    libexec.install Dir["build/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["when"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["when"].stable.checksum
  end
end
