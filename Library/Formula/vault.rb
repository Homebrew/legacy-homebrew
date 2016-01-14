require "language/go"

class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.4.0",
      :revision => "b3da917b2305b23693cf2594f9d29e52acc514cf"
  revision 1

  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76763b87046c6f87dbbaa12de54be683e7ba0d455007bb5566f6132bc6311153" => :el_capitan
    sha256 "387468527a49e69c825c67779f64c206ee756f8b1e42fdd08d1a6c5c2a0a5734" => :yosemite
    sha256 "6c57a4dadb000510cdad4046c85a1572a94e130f21d80b478842621d3f55d3f1" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

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
