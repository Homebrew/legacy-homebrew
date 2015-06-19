class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  url "https://dist.duck.sh/duck-src-4.7.17432.tar.gz"
  sha1 "100996ffbabf2586eb149efd3097b4af20efa728"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "d514c0960a9d735b84257e57f7878b87bdc99d425aa7dd3cab456ec57f5fcafe" => :yosemite
    sha256 "4b2278554fe444de99c510fce0d236058ddf3c63d504a566d3ad33eb34f66b53" => :mavericks
    sha256 "e6963de8e17bd35f4299e9add6176bdb434b9760450019ef1d36ca99577ea73a" => :mountain_lion
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
