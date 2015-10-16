require "language/go"

class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org"
  url "https://github.com/svent/sift/archive/v0.3.4.tar.gz"
  sha256 "88eefbfd02bea5183cedfaab9bfeef397c622a15970b0540ddb4a3e3ea62d775"

  bottle do
    cellar :any_skip_relocation
    sha256 "f25b2fd2cf78435feaec70c86d35534cf1d478349c4dbfcf26c8a195c68cce2c" => :el_capitan
    sha256 "1e3d2c6e561ea99fa05aaded5e17638d48bab4461eb53a52ac8e8876b539c9c5" => :yosemite
    sha256 "c4b04f5414ba2d0fb9d9c1d5b67d58c1b4a02a45af9f3dd5064e7a244f4f8234" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/svent/go-flags" do
    url "https://github.com/svent/go-flags.git", :revision => "4bcbad344f0318adaf7aabc16929701459009aa3"
  end

  go_resource "github.com/svent/go-nbreader" do
    url "https://github.com/svent/go-nbreader.git", :revision => "7cef48da76dca6a496faa7fe63e39ed665cbd219"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"sift"
  end

  test do
    (testpath/"test.txt").write "where is foo"
    assert_match(/where is foo/, shell_output("#{bin/"sift"} foo #{testpath}"))
  end
end
