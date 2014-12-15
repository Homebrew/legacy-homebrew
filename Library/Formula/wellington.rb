require "formula"
require "language/go"

class Wellington < Formula
  homepage "https://github.com/wellington/wellington"
  url "https://github.com/wellington/wellington/archive/2a1f88c8a5bbb151a1c24694fef6602775a98347.tar.gz"
  sha1 "92eb6556a24a9796adb9d238ade41f650c9f7bc0"
  head "https://github.com/wellington/wellington.git"

  needs :cxx11

  depends_on "pkg-config" => :build
  depends_on "libsass" => :build

  go_resource "github.com/wellington/spritewell" do
    url "http://github.com/wellington/spritewell.git",
      :revision => "3a43f26d94a6da8e40884d1edca0ff372ab7487d"
  end

  def install
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
