require "formula"
require "language/go"

class Wellington < Formula
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/f1ef09a7b86e5c96aabe52e76513baa02e929cc7.tar.gz"
  sha1 "90dcae87a3dccd675505b2f23ad47b2ce31fa8fb"
  head "https://github.com/wellington/wellington.git"

  needs :cxx11

  depends_on "pkg-config" => :build
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
    sha1 "48e97c25be75d60429569d406dc482283e213359"
  end

  def install
    resource("github.com/drewwells/libsass").stage do
      ENV["LIBSASS_VERSION"]="1738c7f"
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{buildpath}/libsass",
             "--disable-silent-rules",
             "--disable-dependency-tracking"
      system "make", "install"
    end
    ENV.append_path "PKG_CONFIG_PATH", buildpath/"libsass/lib/pkgconfig"
    mkdir_p buildpath/"src/github.com/wellington"
    ln_s buildpath, buildpath/"src/github.com/wellington/wellington"
    Language::Go.stage_deps resources, buildpath/"src"
    ENV["GOPATH"] = buildpath

    system "go", "build", "-o", "dist/wt", "wt/main.go"
    bin.install "dist/wt"
  end

  test do
    path = testpath/"file.scss"
    path.write "div { p { color: red; }}"
    expected = <<-EOS.undent
      /* line 6, stdin */
      div p {
        color: red; }
    EOS
    output = `#{bin}/wt #{path}`
    assert_equal(expected, output)
  end
end
