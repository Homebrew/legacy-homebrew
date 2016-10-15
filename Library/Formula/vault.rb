require "language/go"

class Vault < Formula
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.1.1",
      :revision => "074dcaadac2e0a46ae28f6d491885165b7431aae"

  head "https://github.com/hashicorp/vault.git"

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep",
        :revision => "58d90f262c13357d3203e67a33c6f7a9382f9223", :using => :git
  end

  # godep's dependencies
  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs",
        :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b", :using => :git
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools",
        :revision => "96f6cfbb921ad6d191c67d09a6d4c4fd056403ae", :using => :git
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox",
        :revision => "e8e6fd4fe12510cc46893dff18c5188a6a6dc549", :using => :git
  end

  # gox dependency
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan",
        :revision => "b584a329b193e206025682ae6c10cdbe03b0cd77", :using => :git
  end

  def install
    gopath = buildpath/"gopath"
    mkdir_p gopath
    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/tools/godep" do
      system "go", "install"
    end

    cd gopath/"src/github.com/mitchellh/gox" do
      system "go", "install"
    end

    mkdir_p gopath/"src/github.com/hashicorp"
    system "git", "clone", buildpath, gopath/"src/github.com/hashicorp/vault"

    cd gopath/"src/github.com/hashicorp/vault" do
      system "make", "dev"
      bin.install "bin/vault"
    end
  end

  test do
    system bin/"vault", "--version"
  end
end
