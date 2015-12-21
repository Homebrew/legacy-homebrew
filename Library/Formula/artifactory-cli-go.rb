class ArtifactoryCliGo < Formula
  desc "Provides a command-line interface for Artifactory."
  homepage "https://github.com/JFrogDev/artifactory-cli-go"
  url "https://github.com/JFrogDev/artifactory-cli-go/archive/1.2.1.tar.gz"
  sha256 "b1224ba6f1dd770b12b9dbd2b38a405a5a06132f60ff94bf3f2775a973e3d1b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b384392c3f0478b96f052c53158a6b882720558cdfca651ab8f8d018f604e0f" => :el_capitan
    sha256 "42c6251ffbeed5ee7ec807f288e2aa40e931c929f2d289680c306d1b03285941" => :yosemite
    sha256 "eb00c774dc85ddc4e4ad64c8da3bead4cbbbc96315815eb0bd307edc8b5589c9" => :mavericks
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
