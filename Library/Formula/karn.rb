require "language/go"

class Karn < Formula
  desc "Manage multiple Git identities"
  homepage "https://github.com/prydonius/karn"
  url "https://github.com/prydonius/karn/archive/v0.0.2.tar.gz"
  sha256 "eac77b82f7abd9c37e70d01240e8e69893b7497d3dd5ab7b0fb2df04ae1e6529"

  bottle do
    cellar :any
    sha256 "217c56700267f33763c3d2c19cb16f568ede2a9354497377639d26c6998f5490" => :yosemite
    sha256 "25ac0041b1023e2b703468d194e554d2dc42664f496f2ca53082003684477ece" => :mavericks
    sha256 "0c5c97266aa7b34fdabaf54b6877b67d279fa643dc264b7f1a1926f2dd1f3790" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "a889873af50a499d060097216dcdbcc26ed09e7c"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2",
        :revision => "49c95bdc21843256fb6c4e0d370a05f24a0bf213", :using => :git
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prydonius"
    ln_s buildpath, buildpath/"src/github.com/prydonius/karn"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "cmd/karn/karn.go"
    bin.install "karn"
  end

  test do
    (testpath/".karn.yml").write <<-EOS.undent
      ---
      #{testpath}:
        name: Homebrew Test
        email: test@brew.sh
    EOS
    system "git", "init"
    system "git", "config", "--global", "user.name", "Test"
    system "git", "config", "--global", "user.email", "test@test.com"
    system "#{bin}/karn", "update"
  end
end
