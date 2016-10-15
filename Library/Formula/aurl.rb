require "language/go"

class Aurl < Formula
  desc "HTTP CLI client with OAuth 2.0 authentication."
  homepage "https://github.com/classmethod-aws/aurl"
  url "https://github.com/classmethod-aws/aurl.git", :tag => "0.3.1", :revision => "b71c9a787f49ff3bddd3199f7aaf9840703e9b9e"

  head "https://github.com/classmethod-aws/aurl.git", :branch => "develop"

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git", :revision => "9b2bd2b3489748d4d0a204fa4eb2ee9e89e0ebc6"
  end

  go_resource "github.com/grategames/ini" do
    url "https://github.com/grategames/ini.git", :revision => "860b5140bc02fe9438df6526fed2348b2b3f192a"
  end

  go_resource "github.com/rakyll/goini" do
    url "https://github.com/rakyll/goini.git", :revision => "907cca0f578a5316fb864ec6992dc3d9730ec58c"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git", :revision => "1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git", :revision => "7dbad50ab5b31073856416cdcfeb2796d682f844"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git", :revision => "11c60b6f71a6ad48ed6f93c65fa4c6f9b1b5b46a"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/classmethod-aws/"
    ln_sf buildpath, buildpath/"src/github.com/classmethod-aws/aurl"
    Language::Go.stage_deps resources, buildpath/"src"

    # Build and install
    system "go", "build", "-o", "aurl"
    bin.install "aurl"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/aurl", "-v"
  end
end
