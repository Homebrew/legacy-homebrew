class ArtifactoryCliGo < Formula
  desc "Provides a command-line interface for Artifactory."
  homepage "https://github.com/JFrogDev/artifactory-cli-go"
  url "https://github.com/JFrogDev/artifactory-cli-go/archive/1.3.0.tar.gz"
  sha256 "29ba6b4cc46456caad300500050548fc0ad157fde102059e0778f0d68a35f4ba"

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
