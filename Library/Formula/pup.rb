require "language/go"

class Pup < Formula
  desc "Parse HTML at the command-line"
  homepage "https://github.com/EricChiang/pup"
  url "https://github.com/ericchiang/pup/archive/v0.3.9.tar.gz"
  sha256 "5e59805edf84d73b2b4c58fe5aeb9a12fc70c028b4aaf58ded6b91ff418b0dda"

  head "https://github.com/EricChiang/pup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3766f1c194ece7e6eea245627c6ca2ae83d7a7cd33dfaf61da53ad85577dfd6" => :el_capitan
    sha256 "0c3f2f89d57313b4d5d90a73c39e5187470e7dd9f35a0d8b030d518f69b21766" => :yosemite
    sha256 "5bc9ab2b8ecb14048115c876bf77a7490139715d3250407785159aa2b72faf8f" => :mavericks
    sha256 "da53aea34a10ecba854eb3f65b451e99fa4dbe5134261ef2deadff8266ff49e2" => :mountain_lion
  end

  depends_on "go" => :build

  # required by gox
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "b584a329b193e206025682ae6c10cdbe03b0cd77"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
    :tag => "v0.3.0", :revision => "54b619477e8932bbb6314644c867e7e6db7a9c71"
  end

  # discovered via
  # find . -name "*.go" -exec head -20 "{}" ";" | grep ".*\..*/" | sort | uniq
  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "b8f08a5598ffe40b0e3f45d483d3cfe3c1dc4964"
  end
  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "8368d3b31cf6f2c2464c7a91675342c9a0ac6658"
  end
  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "d67e0b7d1797975196499f79bcc322c08b9f218b"
  end
  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "a8c61998a557a37435f719980da368469c10bfed"
  end
  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
      :revision => "cee5b80e82c1d078cfdbe853beb9c8318c593677"
  end

  def install
    # For the gox buildtool
    ENV.append_path "PATH", buildpath

    # fake our install so gox will see it
    repo_dir = homepage.downcase.gsub /^https:../, ""
    my_pkg = buildpath / "src/#{repo_dir}"
    prefix.install "LICENSE"
    my_pkg.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    ENV["GOPATH"] = buildpath
    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd my_pkg do
      mkdir "bin"
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox", "-arch", arch,
        "-os", "darwin",
        "-output", "bin/pup-{{.Dir}}",
        "./..."
      bin.install "bin/pup-pup" => "pup"
      # regrettably, there is no manual :-(
    end
  end

  test do
    expected = "Hello"
    actual = pipe_output("pup p \"text{}\"", "<body><p>Hello</p></body>").strip
    assert_equal expected, actual
  end
end
