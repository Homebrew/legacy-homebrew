require "language/go"

class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.3.1",
      :revision => "2b1ddc4a7b7b9754dd55f61494de460fc07239a5"

  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "797cf64812acfe568ac93eb0c0035b7d1703e9541f663806941f1520a8944122" => :el_capitan
    sha256 "5aef06afba8a00c257789729903b9219c7eba09c20fa04808f62f39de64d701d" => :yosemite
    sha256 "a788d3b940c8ec821ab80afaa71e05c35397deb57afc8d9489d9250872979f8a" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git",
        :revision => "e2d1eb1649515318386cc637d8996ab37d6baa5e"
  end

  # godep's dependencies
  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
        :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :revision => "997b3545fd86c3a2d8e5fe6366174d7786e71278"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "a5a468f84d74eb51ece602cb113edeb37167912f"
  end

  # gox dependency
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    contents = Dir["{*,.git,.gitignore,.travis.yml}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/vault").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/tools/godep" do
      system "go", "install"
    end

    cd gopath/"src/github.com/mitchellh/gox" do
      system "go", "install"
    end

    cd gopath/"src/github.com/hashicorp/vault" do
      system "make", "dev"
      bin.install "bin/vault"
    end
  end

  test do
    pid = fork do
      exec "#{bin}/vault", "server", "-dev"
    end
    sleep 1
    ENV.append "VAULT_ADDR", "http://127.0.0.1:8200"
    system "#{bin}/vault", "status"
    Process.kill("TERM", pid)
  end
end
