class GitPolishHistory < Formula
  homepage "https://github.com/schani/git-polish-history"
  url "https://github.com/schani/git-polish-history.git", :tag => "v0.1"

  depends_on "go" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install Go dependencies
    system "go", "get", "-d", "github.com/schani/git2go"
    cd "#{buildpath}/src/github.com/schani/git2go" do
      system "git", "submodule", "update", "--init"
      system "./script/build-libgit2-static.sh"
      system "go", "run", "script/check-MakeGitError-thread-lock.go"
      system "./script/with-static.sh", "go", "test", "./..."
      system "./script/with-static.sh", "go", "install", "./..."
    end

    system "go", "get", "github.com/codegangsta/cli"

    # Build and install
    system "go", "build", "-o", "git-polish-history"
    bin.install "git-polish-history"
  end

  test do
    system "#{bin}/git-polish-history", "help"
  end
end
