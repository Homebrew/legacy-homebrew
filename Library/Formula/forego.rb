require "formula"
require "language/go"

class Forego < Formula
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/v0.13.1.tar.gz"
  sha1 "63ed315ef06159438e3501512a5b307486d49d5c"

  head "https://github.com/ddollar/forego.git"

  bottle do
    sha1 "9eac8ca38f6a4557b30737529f8be85b7afb11bb" => :mavericks
    sha1 "4a08f819f67056758915c4624868e3dc1b012431" => :mountain_lion
    sha1 "1fdb5c2c67b2990a3e71f4d4bde9a872662718c3" => :lion
  end

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

    ldflags = "-X main.Version #{version} -X main.allowUpdate false"
    system "./bin/godep", "go", "build", "-ldflags", ldflags, "-o", "forego"
    bin.install "forego"
  end

  test do
    (testpath/"Procfile").write("web: echo \"it works!\"")
    assert `#{bin}/forego start` =~ /it works!/
  end
end
