require "formula"
require "language/go"

class Pup < Formula
  homepage "https://github.com/EricChiang/pup"
  url "https://github.com/EricChiang/pup/archive/v0.3.1.tar.gz"
  sha1 "56a5b5963428b555a06acc1e4b6feed4332b8f33"

  head "https://github.com/EricChiang/pup.git"

  bottle do
    sha1 "de519f7a2b79fb88c1334a6058baa66d7ddfa99a" => :mavericks
    sha1 "24095aefef241c57a211b5a01c486ebb561d47d7" => :mountain_lion
    sha1 "b76dfd0b50a0f2b96dbe912d73c70b07eb62e0a3" => :lion
  end

  depends_on "go" => :build

  # required by gox
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "b584a329b193e206025682ae6c10cdbe03b0cd77"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git", :tag => "v0.3.0"
  end

  # discovered via
  # find . -name "*.go" -exec head -20 "{}" ";" | grep ".*\..*/" | sort | uniq
  go_resource "github.com/fatih/color" do
    url "git://github.com/fatih/color.git",
        # this was just the `master` at the time of this Formula
        :revision => "3161cccfa22c6243e02aa984cf2886d022024cec"
  end
  go_resource "github.com/mattn/go-colorable" do
    url "git://github.com/mattn/go-colorable.git",
        # this was just the `master` at the time of this Formula
        :revision => "043ae16291351db8465272edf465c9f388161627"
  end
  go_resource "code.google.com/p/go.net" do
    url "https://code.google.com/p/go.net/",
        # this was just the `tip` at the time of this Formula
        :revision => "b39f3d42a398493ea477d6aa63ae43d818d1f78a",
        :using => :hg
  end
  go_resource "code.google.com/p/go.text" do
    url "https://code.google.com/p/go.text/",
        # this was just the `tip` at the time of this Formula
      :revision => "1ac75970ff9e986010d3d7d8549f1863951a9839",
      :using => :hg
  end

  def install
    # For the gox buildtool
    ENV.append_path "PATH", buildpath

    # fake our install so gox will see it
    repo_dir = homepage.downcase.gsub /^https:../, ""
    my_pkg = buildpath / "src/#{repo_dir}"
    prefix.install "LICENSE"
    my_pkg.install Dir["*"]

    Language::Go.stage_deps resources, buildpath / "src"

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
    expected = %{Hello}
    actual = %x{echo "<body><p>Hello</p></body>" | pup p "text{}"}.strip
    assert_equal expected, actual
  end
end
