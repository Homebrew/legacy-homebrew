require "formula"
require "language/go"

class Wellington < Formula
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/v0.4.0.tar.gz"
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
    cleanup = false
    resource("github.com/drewwells/libsass").stage {
      ENV["LIBSASS_VERSION"]="1738c7f"
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{prefix}",
             "--disable-silent-rules",
             "--disable-dependency-tracking"
      system "make", "prefix=#{prefix}", "install"
      # Make libsass.a available to Go compiler
      ln_s "#{prefix}/lib/libsass.a", "/usr/local/lib/libsass.a"
      cleanup = true
    }

    mkdir_p buildpath/"src/github.com/wellington"
    ln_s buildpath, buildpath/"src/github.com/wellington/wellington"
    Language::Go.stage_deps resources, buildpath/"src"
    ENV["GOPATH"] = buildpath

    system "go", "build", "-o", "dist/wt", "wt/main.go"
    # Clean up libsass lib, it will be linked by homebrew after
    if cleanup
      rm "/usr/local/lib/libsass.a"
    end
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
