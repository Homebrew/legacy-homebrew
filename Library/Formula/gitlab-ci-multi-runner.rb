class GitlabCiMultiRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner"
  url "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git",
    :tag => "v0.7.2",
    :revision => "998cf5d5ef3caf6535cc4c5f3279b08c3ee2ecc8"

  head "https://gitlab.com/gitlab-org/gitlab-ci-multi-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ec8bce6be01aa22a2efafe18c091a397914e6ef500df33d82e4b76f658a8fbe" => :el_capitan
    sha256 "985fb658f94d106a335e1b11e085e2606e3d6c5a0de9efac9fabda36eaccc497" => :yosemite
    sha256 "6456a87e5091b8c8f44d260e56dbf5e8e8783a060f59dba83bbb7a06f007ee45" => :mavericks
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
