class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v0.6.2",
    :revision => "3227f0aa5be1d64d2ec694bd3758e0d43e92b36b"

  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed05bd9d27b5c4541add770d71af010471b91d107137398344ae630609abd293" => :el_capitan
    sha256 "78659d13de49d5dcd348b7dbade44047b448912070b68ecd6bc5e7a376652dbb" => :yosemite
    sha256 "b687dc1dcf9886a02b25188af0c4f38548ec23a7f3c848b95e8e2b5e1108db0f" => :mavericks
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
    end
  end

  test do
    assert_match /gitlab-ci-multi-runner version #{version}/, shell_output("gitlab-ci-multi-runner --version")
  end
end
