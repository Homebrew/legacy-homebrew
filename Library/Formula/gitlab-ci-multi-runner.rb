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

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/gitlab.com/gitlab-org"
    ln_sf buildpath, buildpath/"src/gitlab.com/gitlab-org/gitlab-ci-multi-runner"

    # gitlab-ci-multi-runner's deps is managed by godeps
    ENV.append_path "GOPATH", "#{buildpath}/Godeps/_workspace"

    cd "src/gitlab.com/gitlab-org/gitlab-ci-multi-runner" do
      commit_sha = `git rev-parse --short HEAD`

      # Copy from Makefile
      system "go", "build", "-o", "gitlab-ci-multi-runner", "-ldflags", "-X main.NAME=gitlab-ci-multi-runner -X main.VERSION=#{version} -X main.REVISION=#{commit_sha}"
      bin.install "gitlab-ci-multi-runner"
      bin.install_symlink "#{bin}/gitlab-ci-multi-runner" => "gitlab-runner"
    end
  end

  test do
    assert_match "gitlab-ci-multi-runner version #{version}", shell_output("#{bin}/gitlab-ci-multi-runner --version")
    assert_match "gitlab-runner version #{version}", shell_output("#{bin}/gitlab-runner --version")
  end
end
