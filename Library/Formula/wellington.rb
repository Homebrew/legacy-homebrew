require "formula"
require "language/go"

class Wellington < Formula
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/f1ef09a7b86e5c96aabe52e76513baa02e929cc7.tar.gz"
  sha1 "a5aa2866bcb914fd40542089628d5604de85c207"
  head "https://github.com/wellington/wellington.git"

  option :cxx11

  depends_on "go" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  go_resource "github.com/wellington/spritewell" do
    url "http://github.com/wellington/spritewell.git",
      :revision => "3a43f26d94a6da8e40884d1edca0ff372ab7487d"
  end

  resource "github.com/drewwells/libsass" do
    url "http://github.com/drewwells/libsass.git"
    sha1 "1738c7f"
  end

  def install
    resource("github.com/drewwells/libsass").stage {
      ENV["LIBSASS_VERSION"]="1738c7f"
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{prefix}",
             "--disable-silent-rules",
             "--disable-dependency-tracking"
      system "make", "install"
    }

    mkdir_p buildpath/"src/github.com/wellington"
    ln_s buildpath, buildpath/"src/github.com/wellington/wellington"
    Language::Go.stage_deps resources, buildpath/"src"
    ENV["GOPATH"] = buildpath

    system "go", "build", "-o", "dist/wt", "wt/main.go"
    bin.install "dist/wt"
  end

  test do
    path = testpath/"file.scss"
    path.write "div { p { color: red; } }"
    lines = `#{bin}/wt #{path}`
    assert_equal(`div p {
  color: red; }`, lines)
  end
end
