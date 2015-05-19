require "language/go"

class Wellington < Formula
  desc "Adds file awareness to SASS"
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/v0.8.1.tar.gz"
  sha256 "77b41ee1b3e0095dd54a8575c6b05fdef7bf7bc059b46e534b3d06f84ab2422c"
  head "https://github.com/wellington/wellington.git"

  bottle do
    cellar :any
    sha256 "c997930e1d617e3bc0f09136c3d102c592634cec1d9ef8c9e26c1592af58619f" => :yosemite
    sha256 "fed8ce27ec30e8d648fd148dc83d7ad937456b04a7b1d5eb435ed0db4fae6698" => :mavericks
    sha256 "e3fa0c5f9dea85b93b43f4cc4681c8e67dcfbf4dae34a51d0a59f81c6fed063a" => :mountain_lion
  end

  needs :cxx11

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  stable do
    depends_on "libsass"
  end

  devel do
    url "https://github.com/wellington/wellington/archive/c574754c39806e8c52682f15f49c8ff819d0f962.tar.gz"
    sha256 "92c5d4bdd6260f96aed0e20fa06c6200b1c57281dbd32dbd00b1c06636ef6e10"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  head do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git", :revision => "58d90f262c13357d3203e67a33c6f7a9382f9223"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git", :revision => "473fd854f8276c0b22f17fb458aa8f1a0e2cf5f5"
  end

  def install
    version = File.read("version.txt").chomp
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end
    system "bin/godep", "restore"

    # Build libsass from source for devel build
    unless stable?
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
    output = `echo '#{s}' | #{bin}/wt`
    assert_equal(expected, output)
  end
end
