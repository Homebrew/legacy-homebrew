require "language/go"

class Cig < Formula
  desc "CLI app for checking the state of your git repositories"
  homepage "https://github.com/stevenjack/cig"
  url "https://github.com/stevenjack/cig/archive/v0.1.5.tar.gz"
  sha256 "545a4a8894e73c4152e0dcf5515239709537e0192629dc56257fe7cfc995da24"
  head "https://github.com/stevenjack/cig.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c64c5aaab66ee0853e0b3437c002dcf233fd543a019e4b411f9cf3f9555de702" => :el_capitan
    sha256 "d349ccf020a30a7db72333a4aa1a8f73bcb2b3c6f0984c7a0e88de38bc07ed4c" => :yosemite
    sha256 "b61176af3e53d2505f36ee3deafbb92a5f02f6c0841fefdcdfdd084821a95837" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git", :revision => "473fd854f8276c0b22f17fb458aa8f1a0e2cf5f5"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/stevenjack/"
    ln_sf buildpath, buildpath/"src/github.com/stevenjack/cig"
    Language::Go.stage_deps resources, buildpath/"src"

    system "godep", "go", "build", "-o", "cig", "."
    bin.install "cig"
  end

  test do
    repo_path = "#{testpath}/test"
    system "git", "init", "--bare", repo_path
    (testpath/".cig.yaml").write <<-EOS.undent
      test_project: #{repo_path}
    EOS
    system "#{bin}/cig", "--cp=#{testpath}"
  end
end
