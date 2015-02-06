require "formula"
require "language/go"

class Rocket < Formula
  homepage "https://github.com/coreos/rocket"
  head "https://github.com/coreos/rocket.git"

  url "https://github.com/coreos/rocket/archive/v0.3.0.tar.gz"
  sha1 "544046470a97abdc10c82b27b049857e690795b7"

  bottle do
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

    ENV["GOOS"] = `uname`.downcase.strip

    # This stops [0] from executing, which is tied specifically to the Linux networking stack
    # [0]: https://github.com/coreos/rocket/blob/6e0404bb0edc11c84a6ca5e3d0b7af9839f85cfa/build#L16-L23
    inreplace "build", 'echo "Building network plugins"', "if false; then"
    inreplace "build", 'echo "Building rkt (stage0)..."', "fi"

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
