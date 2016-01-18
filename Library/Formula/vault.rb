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
    sha256 "41aacbabd07b3084f62d4beb27e524185a07c349ead5f532f8c095d2cc37cbe9" => :el_capitan
    sha256 "60c643c46e4bdedf3cb278e4929edfa58471b192a828aed4ca902f79179109ad" => :yosemite
    sha256 "9e2a67a91df6f2734354bd58a0e1061f0a5cd146d3b976c99e52af17a3a62a3d" => :mavericks
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
