require "formula"
require "language/go"

class Rocket < Formula
  desc "App Container runtime"
  homepage "https://github.com/coreos/rocket"
  head "https://github.com/coreos/rocket.git"

  url "https://github.com/coreos/rocket/archive/v0.1.0.tar.gz"
  sha1 "04ae8cb9bac04eedacb03a7531e6b251556be653"

  bottle do
    cellar :any
    sha1 "cb111d426363b5df807800ccf6b2f6eba7cdf10f" => :yosemite
    sha1 "cd464addb3a1364a621aa64e0239a0d10ef11e65" => :mavericks
    sha1 "70bf2fffc71a3e3c948bd20854880d2dca267611" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on "squashfs" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata/archive/v3.0.7.tar.gz"
    sha1 "b348b4f39204a31a87fd396ea1418e2ef5b07e90"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    cd "#{buildpath}/src/github.com/jteeuwen/go-bindata" do
      system "go", "install", "github.com/jteeuwen/go-bindata/..."
    end
    ENV.prepend_path "PATH", buildpath/"bin"

    inreplace "build", "GOOS=linux", "GOOS=#{`uname`.downcase}"

    # Fix non-POSIX commands realpath and mktemp
    # See https://github.com/coreos/rocket/pull/196
    inreplace "build", "$(mktemp -d)", "$(mktemp -d -t rocket-XXXXXX)"
    inreplace "stage1/mkrootfs.sh", '$(realpath "${BINDIR}")', '"${PWD}${BINDIR}"'

    system "./build"
    bin.install "bin/actool", "bin/rkt"
    doc.install "README.md"
  end

  test do
    system "#{bin}/actool", "help"
    system "#{bin}/rkt", "help"
    assert_equal "sha256-08699361d40a0728924ffe6fcd67dc933d7311cf8e6f403048c9271181b20e2e\n",
      `#{bin}/rkt --dir=$PWD fetch https://github.com/coreos/rocket/releases/download/v0.1.0/ace-validator-main.aci`
  end
end
