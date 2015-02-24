require "language/go"

class Wellington < Formula
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/0.6.0.tar.gz"
  sha1 "c7d1c391f9e929796f92c4496f011c62546a12cd"
  head "https://github.com/wellington/wellington.git"

  bottle do
    sha1 "4c2de0af6f0d18032e3d3722a328cbab4ca555d2" => :yosemite
    sha1 "93fe2f24e449f8892d1401cf3fb8f9642d11d1ff" => :mavericks
    sha1 "84d4941117e47a9c865aa5b9ac1c1f97295a04f9" => :mountain_lion
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
