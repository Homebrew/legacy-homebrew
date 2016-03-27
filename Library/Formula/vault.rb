require "language/go"

# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.5.2",
      :revision => "77f2b8a2fa408e0fc77ed7402d51cf0cfa0335d7"

  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91c1c51230de2293299ebd5126751484f74c5173cbd7738d9278cca61ed65560" => :el_capitan
    sha256 "f9afb31390b5e347b0ec6bd1e375938a4ab530455c4b6e37b767630e4091c65c" => :yosemite
    sha256 "abcab81352fef3223c675200fc58db92c809510d2453ee2b03fd7ce672b46333" => :mavericks
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
        :revision => "fe74a4186116b8d7dd38a723993e0d84f8834b34"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "39862d88e853ecc97f45e91c1cdcb1b312c51eaa"
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
