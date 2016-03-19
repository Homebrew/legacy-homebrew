require "language/go"

class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.0.1.tar.gz"
  sha256 "9189993c3201dc354a73fdbd5dfdecb8ae077ef06e2d3badc6ac6450e7c64eaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9e33779cdb02d40a621f1a14c8b9468ebd2ee4e746d4a4a9025cd35ca5c5839" => :el_capitan
    sha256 "4477e7b944a650ebfc67bbb01e696f686da774c8afa4652c0d4600eabfa392fd" => :yosemite
    sha256 "de7cc596e735094e440d2814a27c9bd1b11e6ca40e55dc93e45d9be987b0f75f" => :mavericks
  end

  depends_on "go" => :build

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "c197bcf24cde29d3f73c7b4ac6fd41f4384e8af6"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JFrogDev/").mkpath
    ln_sf buildpath, buildpath/"src/github.com/JFrogDev/jfrog-cli-go"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/jfrog", "github.com/jfrogdev/jfrog-cli-go/jfrog"
  end

  test do
    actual = pipe_output("#{bin}/jfrog rt -v")
    expected = "jfrog version 1.0.1\n"
    assert_equal expected, actual
  end
end
