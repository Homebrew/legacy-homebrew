require "language/go"

class Vault < Formula
  desc "secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.3.0",
      :revision => "347f48c55bae0fa7a36d8eae6028de9a6eeefc01"

  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8591e186a3eba4f963821ff8c90ee24597cf937a2ed999d22f0a733487aef82" => :el_capitan
    sha256 "6ec4ce0956d895329e34a84483d61a49bf322d0ad9d65752a4c3f1f2cde38a25" => :yosemite
    sha256 "83949323d8a0aa09528c17d9326d77138c8c9d0f51454b34ec7cde79627a7913" => :mavericks
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
