class ArtifactoryCliGo < Formula
  desc "Provides a command-line interface."
  homepage "https://www.jfrog.com"
  url "https://github.com/JFrogDev/artifactory-cli-go/archive/1.2.0.tar.gz"
  sha256 "173a24e0b821c6ff2bb85fa4cbe733fa681a8284029b77387baf0fa5f2fcfc4e"
  depends_on "go"
  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"
    (buildpath/"src/github.com/JFrogDev/artifactory-cli-go/").install Dir["*"]
    system "go", "build", "-v", "github.com/JFrogDev/artifactory-cli-go/art/"
    bin.install "art"
  end
  test do
    system "#{bin}/art", "-v"
    actual = pipe_output("#{bin}/art upload")
    expected = "Wrong number of arguments. Try 'art upload --help'.\n"
    assert_equal expected, actual
  end
end
