class GitlabRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git", :tag => "v0.6.2", :revision => "3227f0aa5be1d64d2ec694bd3758e0d43e92b36b"

  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

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
      system "go", "build", "-o", "gitlab-runner", "-ldflags", "-X main.NAME=gitlab-runner -X main.VERSION=#{version} -X main.REVISION=#{commit_sha}"
      bin.install "gitlab-runner"
    end
  end

  test do
    assert_match /gitlab-runner version #{version} (.*)/, shell_output("gitlab-runner --version")
  end
end
