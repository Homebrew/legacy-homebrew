require "language/go"

class LetMeIn < Formula
  desc "Add my IP to AWS security group(s)"
  homepage "https://github.com/rlister/let-me-in"
  url "https://github.com/rlister/let-me-in/archive/v0.0.4.tar.gz"
  sha256 "b073cc8df2e4412e20f056874502d1dffc15cf01bd3bfb34f161a7157788fbc1"

  depends_on "go" => :build

  ## install godep, which will handle all remaining vendored dependencies
  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git", :revision => "25d294f55e782c93ecfa0db046f095549ac5b960"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/rlister/"
    ln_sf buildpath, buildpath/"src/github.com/rlister/let-me-in"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end

    system "./bin/godep", "go", "build", "-o", "let-me-in"
    bin.install "let-me-in"
  end

  test do
    ## I should write some tests
  end
end
