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
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    ENV.cxx11
    ENV["PKG_CONFIG_PATH"] = buildpath/"src/github.com/wellington/go-libsass/lib/pkgconfig"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end
    system "./bin/godep", "restore"

    ENV.append "CGO_LDFLAGS", "-stdlib=libc++" if ENV.compiler == :clang
    cd "src/github.com/wellington/go-libsass/" do
      system "make", "deps"
    end

    # symlink into $GOPATH so builds work
    mkdir_p buildpath/"src/github.com/wellington"
    ln_s buildpath, buildpath/"src/github.com/wellington/wellington"

    system "./bin/godep", "go", "build", "-o", "dist/wt", "wt/main.go"
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
