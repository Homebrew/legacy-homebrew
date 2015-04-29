require "language/go"

class Wellington < Formula
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/v0.7.1.tar.gz"
  sha256 "3f23fffee02ce03f177fb1489f3dee92879c59edda6230e5a2c16aaa149fb1a8"
  head "https://github.com/wellington/wellington.git"

  bottle do
    cellar :any
    sha256 "9054893acde51c1fc992dc4172e0eb5177e08755fa7397624803bc3dc678fea7" => :yosemite
    sha256 "495c1410412a58dac9c8643dee36130a2becc75d853b03c24a694824005664e8" => :mavericks
    sha256 "8e132ad0a7183d9ce11f64c342b6db7f1ba2e33d096a1f5f1bd85b56354c2751" => :mountain_lion
  end

  needs :cxx11

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  go_resource "github.com/wellington/spritewell" do
    url "https://github.com/wellington/spritewell.git",
        :revision => "748bfe956f31c257605c304b41a0525a4487d17d"
  end

  go_resource "github.com/go-fsnotify/fsnotify" do
    url "https://github.com/go-fsnotify/fsnotify.git",
        :revision => "f582d920d11386e8ae15227bb5933a8f9b4c3dec"
  end

  def install
    ENV.cxx11
    # go_resource doesn't support gopkg, do it manually then symlink
    mkdir_p buildpath/"src/gopkg.in"
    ln_s buildpath/"src/github.com/go-fsnotify/fsnotify",
         buildpath/"src/gopkg.in/fsnotify.v1"
    ENV["PKG_CONFIG_PATH"] = buildpath/"libsass/lib/pkgconfig"
    mkdir_p buildpath/"src/github.com/wellington"
    ln_s buildpath, buildpath/"src/github.com/wellington/wellington"
    Language::Go.stage_deps resources, buildpath/"src"
    ENV["GOPATH"] = buildpath
    ENV.append "CGO_LDFLAGS", "-stdlib=libc++" if ENV.compiler == :clang
    system "make", "deps"
    system "go", "build", "-x", "-v", "-o", "dist/wt", "wt/main.go"

    bin.install "dist/wt"
  end

  test do
    s = "div { p { color: red; } }"
    expected = <<-EOS.undent
      Reading from stdin, -h for help
      /* line 6, stdin */
      div p {
        color: red; }
    EOS
    output = `echo '#{s}' | #{bin}/wt`
    assert_equal(expected, output)
  end
end
