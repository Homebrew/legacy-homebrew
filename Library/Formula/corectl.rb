require "language/go"

class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.5.4.tar.gz"
  sha256 "1ff7032d51d4a8e4581f0c10c1446acac8bf34768ec31d20eb459b90c160110d"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6a04c526b14786d7224ff3a45b3f2897a0b7cd19ee580f3bd48b6c71e5c5b82" => :el_capitan
    sha256 "f92bae6c828bdfc24618f5d49dc9ee05953763e1785909ed0c2b5ca11763eb0b" => :yosemite
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
