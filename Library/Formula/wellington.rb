require "language/go"

class Wellington < Formula
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/v0.7.0.tar.gz"
  sha1 "0fadaacaef7ff7ccbdf0c8e3994e3cf5d2de420e"
  head "https://github.com/wellington/wellington.git"

  bottle do
    cellar :any
    sha256 "47a6b8112532da003dedb42e67b6f0f5233e832813487d7eec310d9ed1a68208" => :yosemite
    sha256 "6d7b6a9ed8e30b28994db5f0f0cf87bf7e95e08ed78238f789538cceb0cb8fd3" => :mavericks
    sha256 "e1dbb489f6bc3e184798d30c0d760db0235260ee55fb1af35f2deed3835a5cc3" => :mountain_lion
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
