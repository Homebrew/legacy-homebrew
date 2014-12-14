require "formula"
require "language/go"

class Wellington < Formula
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/64e1fcd9546ccfee8d2eb8faf6c8990d21312317.tar.gz"
  sha1 "c8365c89e12db55b5ad2a57bd84688f8053ce42c"
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
      ENV["LIBSASS_VERSION"] = "48e97c25be75d60429569d406dc482283e213359"
      system "autoreconf", "-fvi"
      system "./configure",
             "--enable-static",
             "PKG_CONFIG=\"pkg-config --static\"",
             "--prefix=#{buildpath}/libsass",
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
