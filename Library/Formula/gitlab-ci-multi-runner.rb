require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v1.0.4",
    :revision => "014aa8c265cc5d96e7359b6d55a8f8468b2959dc"

  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "60ed30aa096a7306e13dc9a8d0d3f227a98947823125470175aee91e8cf600bd" => :el_capitan
    sha256 "5afef9708d4d728589583e2217a8a5679d3f00f99c3e80661478daf712551933" => :yosemite
    sha256 "455097004bb8c7b46ca4dad64634cdc60085a0f9c54dcfeab19802c2f5486cb3" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "docker" => :recommended

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  resource "prebuilt.tar.gz" do
    url "https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v1.0.4/docker/prebuilt.tar.gz",
      :using => :nounzip
    sha256 "43dedd023672990e27289e97bf74f493576956418148f6227917b8511e8aadfd"
  end

  def install
    mkdir_p buildpath/"src/gitlab.com/gitlab-org"
    ln_sf buildpath, buildpath/"src/gitlab.com/gitlab-org/gitlab-ci-multi-runner"

    ENV["GOPATH"] = buildpath

    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath/"src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    resource("prebuilt.tar.gz").stage do
      system "go-bindata", "-pkg", "docker", "-nocompress", "-nomemcopy", "-nometadata", "-o", buildpath/"executors/docker/bindata.go", "prebuilt.tar.gz"
    end

    cd "src/gitlab.com/gitlab-org/gitlab-ci-multi-runner" do
      commit_sha = `git rev-parse --short HEAD`

      # Disable vendor support for go 1.5 and above
      ENV["GO15VENDOREXPERIMENT"] = "0"

      # Copy from Makefile
      system "godep", "go", "build", "-o", "gitlab-ci-multi-runner", "-ldflags", "-X main.NAME=gitlab-ci-multi-runner -X main.VERSION=#{version} -X main.REVISION=#{commit_sha}"
      bin.install "gitlab-ci-multi-runner"
      bin.install_symlink "#{bin}/gitlab-ci-multi-runner" => "gitlab-runner"
    end
  end

  test do
    assert_match "gitlab-ci-multi-runner version #{version}", shell_output("#{bin}/gitlab-ci-multi-runner --version")
    assert_match "gitlab-runner version #{version}", shell_output("#{bin}/gitlab-runner --version")
  end
end
