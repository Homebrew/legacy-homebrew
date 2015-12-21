class ArtifactoryCliGo < Formula
  desc "Provides a command-line interface for Artifactory."
  homepage "https://github.com/JFrogDev/artifactory-cli-go"
  url "https://github.com/JFrogDev/artifactory-cli-go/archive/1.2.1.tar.gz"
  sha256 "b1224ba6f1dd770b12b9dbd2b38a405a5a06132f60ff94bf3f2775a973e3d1b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "e753b74c3c36d0821d8ff86e47cf5d179375ac9d99c36dbf8dd292cfe7e0cd10" => :el_capitan
    sha256 "4383de4b0cfa38dd3ca335c6d8784f6da8644556e7104efffc61addcab3cec23" => :yosemite
    sha256 "30e498c38bed5795da200238c8bf5b0a605c70a6aaa28aafa23a2616584877f3" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"
    (buildpath/"src/github.com/JFrogDev/artifactory-cli-go/").install Dir["*"]
    system "go", "build", "-o", "#{bin}/art", "-v", "github.com/JFrogDev/artifactory-cli-go/art/"
  end

  test do
    actual = pipe_output("#{bin}/art upload")
    expected = "The --url option is mandatory\n"
    assert_equal expected, actual
  end
end
