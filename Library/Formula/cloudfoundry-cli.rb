require "formula"

class CloudfoundryCli < Formula
  homepage "https://github.com/cloudfoundry/cli"
  head "https://github.com/cloudfoundry/cli.git", :branch => "master"
  url "https://github.com/cloudfoundry/cli/archive/v6.1.2.tar.gz"
  sha1 "33b3d78929dc145b5d01f48e8c700d77c577ec8e"

  resource "github.com/kr/fs" do
    url "https://github.com/kr/fs/archive/2788f0dbd1.tar.gz"
    sha1 "4edb51785649aab8307224d102d92fd895fc644a"
  end

  resource "github.com/tools/godep" do
    url "https://github.com/tools/godep/archive/c703322617.tar.gz"
    sha1 "93257dc673634a919500555416b4ab7a66bc806d"
  end

  resource "code.google.com/p/go.tools" do
    url "https://code.google.com/p/go.tools", :using => :hg, :revision => "16246baf70e788607b3cf6bc44c85db71c427dc4"
    sha1 "f043dd9cb4e2a766afac17672a43a2cf1bf3b6a8"
  end

  bottle do
    sha1 "f72539292f35aa0c7e66536494b895253cd3a667" => :mavericks
    sha1 "c43cb7af262a83f0aaf330fafd6c6be61afb01e9" => :mountain_lion
    sha1 "1d2942622b9571874910314c8d89fb0c837eaf47" => :lion
  end

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = buildpath
    cli_source    = buildpath + "src/github.com/cloudfoundry/cli"

    mkdir_p cli_source
    Dir["*"].reject { |p| p =~ /^src$/ }.each { |p| mv p, cli_source }

    f.resources.each do |resource|
      resource.stage buildpath/"src"/resource.name
    end

    system "go", "install", "github.com/tools/godep"

    Dir.chdir cli_source do
      system "#{buildpath}/bin/godep restore"
      inreplace "cf/app_constants.go", "BUILT_FROM_SOURCE", "#{version}-homebrew"
      inreplace "cf/app_constants.go", "BUILT_AT_UNKNOWN_TIME", Time.now.utc.iso8601
      system "bin/build"
    end

    bin.install cli_source + "out/cf"
    doc.install cli_source + "LICENSE"
  end

  test do
    system "#{bin}/cf"
  end
end
