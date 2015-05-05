require "language/go"

class Pup < Formula
  homepage "https://github.com/EricChiang/pup"
  url "https://github.com/ericchiang/pup/archive/v0.3.9.tar.gz"
  sha256 "5e59805edf84d73b2b4c58fe5aeb9a12fc70c028b4aaf58ded6b91ff418b0dda"

  head "https://github.com/EricChiang/pup.git"

  bottle do
    cellar :any
    sha256 "df4845eacaf13a885015266fa87b282b99cec7d59d216a0d5f0ded35dcfb8ea6" => :yosemite
    sha256 "a7013f00f515a8e2f5c290d5b540ed7356504ba1843149782e1cf2d89aabcf13" => :mavericks
    sha256 "0ecbecac78ddb4b50b4b6d1caf24524d3751d8e0348411e767253fc694546e0c" => :mountain_lion
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
