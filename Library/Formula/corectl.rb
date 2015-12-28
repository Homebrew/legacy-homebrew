require "language/go"

class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.0.19.tar.gz"
  sha256 "323ebe7e3f612a2656e4b844793f62433a46604ee78455446e04db6b8bc0247e"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b7e4448041f4f8823a2fdeed3cd5004bb44db0a5cf9e7e97c4dee366df89dbc" => :el_capitan
    sha256 "81e1292f45a96ac886be4514599303e319b077877f7eb90ca8591c269a00cc20" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "gnu-sed" => :build
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/TheNewNormal/"
    ln_s buildpath, buildpath/"src/github.com/TheNewNormal/#{name}"
    Language::Go.stage_deps resources, buildpath/"src"

    args = []
    args << "VERSION=#{version}" if build.stable?

    # system "make", "corectl", *args
    # busts with "cannot load DWARF output from ""...
    # similar to https://github.com/jwaldrip/homebrew-utils/issues/1
    # workaround ...
    ["TheNewNormal/libxhyve", "TheNewNormal/corectl/uuid2ip",
     "yeonsh/go-ps"].each do |repo|
      system "godep", "go", "install", "github.com/#{repo}"
    end

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
