require "language/go"

class Wellington < Formula
  desc "Adds file awareness to SASS"
  homepage "https://github.com/wellington/wellington"

  stable do
    url "https://github.com/wellington/wellington/archive/v0.9.1.tar.gz"
    sha256 "133a3d698f98139808c4a86955a9cdc0d9e91a0ed886c0851aceaed4595d8022"

    depends_on "libsass"
  end

  bottle do
    cellar :any
    sha256 "843f251fe4157482b0c758512f734c7931016e9fcfd501ed1a5e267ac3efcd36" => :yosemite
    sha256 "860cdde8a2327cfd11910fb434f3c9666e1b186928c6fbf5cb106eb5d7f19ae9" => :mavericks
    sha256 "10c2b1bbbe26bbfd5f5644c1d0047292b896d6b5555e275d0d47788566e7973f" => :mountain_lion
  end

  needs :cxx11

  head do
    url "https://github.com/wellington/wellington.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git",
      :revision => "fe7138c011ae7875d4af21efe8b237f4987d8c4a"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
      :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git",
      :revision => "ea5101579e09ace53571c8a5bae6ebb896f8d5e4"
  end

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    version = File.read("version.txt").chomp
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end
    system "bin/godep", "restore"

    # Build libsass from source for head build
    if build.head?
      ENV.cxx11
      ENV["PKG_CONFIG_PATH"] = buildpath/"src/github.com/wellington/go-libsass/lib/pkgconfig"

      ENV.append "CGO_LDFLAGS", "-stdlib=libc++" if ENV.compiler == :clang
      cd "src/github.com/wellington/go-libsass/" do
        system "make", "deps"
      end
    end

    # symlink into $GOPATH so builds work
    mkdir_p buildpath/"src/github.com/wellington"
    ln_s buildpath, buildpath/"src/github.com/wellington/wellington"

    system "go", "build", "-ldflags", "-X main.version #{version}", "-o", "dist/wt", "wt/main.go"
    bin.install "dist/wt"
  end

  test do
    s = "div { p { color: red; } }"
    expected = <<-EOS.undent
      Reading from stdin, -h for help
      /* line 1, stdin */
      div p {
        color: red; }
    EOS
    assert_equal expected, pipe_output("#{bin}/wt", s, 0)
  end
end
