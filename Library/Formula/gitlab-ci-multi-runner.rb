require "language/go"

class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v1.1.0",
    :revision => "a23a25ab6423988d93e2382af3674f4b76cc2813"

  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e684eac71bf956dfe518120969a72510eaa56166963a3ea662518b5e40872bee" => :el_capitan
    sha256 "f9c5065178642e1aa8c654b814a0d0f70e7319881ee0348bf10adec71a931a87" => :yosemite
    sha256 "8db608b86731094140345656bddfb75400e09f5de025feedce2226dabd953cf0" => :mavericks
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
