class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-4.7.1.17911.tar.gz"
  sha256 "51cf135a12743c0a524c23adeab13f01a635999f8b03122eaf06056e320d365d"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "bfe86da78894f372c068519d0ad4c460bc30f575fa7d340fc598ca8347b959c2" => :yosemite
    sha256 "815df4596b0403106df8a896c250af44b76ecaf1670a239b97a7c5926ce95d71" => :mavericks
    sha256 "e0183f13dcf4caa7522b25896708ad2ba1de370749eae07a0216c44b408f6223" => :mountain_lion
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
    filename = (testpath/"test")
    system "#{bin}/duck", "--download", stable.url, filename
    filename.verify_checksum stable.checksum
  end
end
