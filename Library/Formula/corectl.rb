require "language/go"

class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.5.1.tar.gz"
  sha256 "326d51a333d61d2dbe0398947dd45fd51a0d918b4649022b317c1e58ebf5fc0d"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "557876385a867b0336b16b56e14cc5ac94c0def9608277a63a46e7c7b9e4aba3" => :el_capitan
    sha256 "672d092d889293e7e28a4ca98ec85df99315ff76c03b95d4cad3fa255c7bd543" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/TheNewNormal/"
    ln_s buildpath, buildpath/"src/github.com/TheNewNormal/#{name}"
    Language::Go.stage_deps resources, buildpath/"src"

    args = []
    args << "VERSION=#{version}" if build.stable?

    system "make", "corectl", *args
    system "make", "documentation/man"

    bin.install "corectl"
    man1.install Dir["documentation/man/*.1"]
    share.install "cloud-init", "profiles"
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/corectl version"))
  end
end
