require "language/go"

class LetMeIn < Formula
  desc "Add my IP to AWS security group(s)"
  homepage "https://github.com/rlister/let-me-in"
  url "https://github.com/rlister/let-me-in/archive/v0.0.7.tar.gz"
  sha256 "0649af91522879fdad2584171e512e971e5561e59d88bedb8e22afbcca2e05ef"

  depends_on "go" => :build

  head "https://github.com/rlister/let-me-in.git"

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

    system "./bin/godep", "go", "build", "-ldflags", "-X main.VERSION=#{version}", "-o", "let-me-in"
    bin.install "let-me-in"
  end

  test do
    assert_match /let-me-in #{version}/, shell_output("#{bin}/let-me-in -v")
  end
end
