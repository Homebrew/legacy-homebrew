require "formula"
require "language/go"

class Forego < Formula
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/v0.12.0.tar.gz"
  sha1 "377a77cd522ccf00b274645920fc760f27b16ed4"

  head "https://github.com/ddollar/forego.git"

  depends_on "go" => :build

  go_resource "github.com/kr/godep" do
    url "https://github.com/kr/godep.git", :revision => "edcaa96f040b31f4186738decac57f88d6061b8d"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "code.google.com/p/go.tools" do
    url "https://code.google.com/p/go.tools/", :revision => "140fcaadc586", :using => :hg
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/kr/godep" do
      system "go", "install"
    end

    system "./bin/godep", "go", "build", "-o", "forego"
    bin.install "forego"
  end

  test do
    (testpath/"Procfile").write("web: echo \"it works!\"")
    assert `#{bin}/forego start` =~ /it works!/
  end
end
