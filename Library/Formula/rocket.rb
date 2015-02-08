require "formula"
require "language/go"

class Rocket < Formula
  homepage "https://github.com/coreos/rocket"
  head "https://github.com/coreos/rocket.git"

  url "https://github.com/coreos/rocket/archive/v0.3.1.tar.gz"
  sha1 "c044b8838515ab9898b943d26e0a4cee666df78c"

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

  # This patch prevents non-linux OSs from trying to compile linux networking
  # https://github.com/coreos/rocket/pull/490
  patch do
    url "https://github.com/jzelinskie/rocket/commit/67e4247e25bd8a19ab5acc7a08b83d85c4321132.diff"
    sha1 "fce033178b7d970310c35dc4525e5d41eb817e9b"
  end

  # This patch fixes compilation on Go 1.4 due Godep not stripping import comments
  patch do
    url "https://github.com/coreos/rocket/commit/8f60b1afb350ff99c84583a0bd228298f6554b3e.diff"
    sha1 "0ad1f3d118cbfd47c571b0bf358aa01dfea8c789"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    cd "#{buildpath}/src/github.com/jteeuwen/go-bindata" do
      system "go", "install", "github.com/jteeuwen/go-bindata/..."
    end
    ENV.prepend_path "PATH", buildpath/"bin"

    ENV["GOOS"] = `uname`.downcase.strip

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
