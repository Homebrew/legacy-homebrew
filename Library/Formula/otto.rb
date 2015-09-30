require "language/go"

class Otto < Formula
  desc "Development and deployment system designed as the successor to Vagrant"
  homepage "https://ottoproject.io"
  url "https://github.com/hashicorp/otto.git",
      :tag => "v0.1.1",
      :revision => "257771b197d5a52bfb5c26205872969c328fca91"

  head "https://github.com/hashicorp/otto.git"

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git",
        :revision => "2c6ee5e071cf01a41359e33502b7fe79a5801b9e"
  end

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
        :revision => "bfe36d3254337b7cc18024805dfab2106613abdf"
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
        :revision => "ef1967b9f538fe467e6a82fc42ec5dff966ad4ea"
  end

  # gox dependency
  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  def install
    contents = Dir["{*,.git,.gitignore,.travis.yml}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/otto").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/tools/godep" do
      system "go", "install"
    end

    cd gopath/"src/github.com/jteeuwen/go-bindata/go-bindata" do
       system "go", "install"
    end

    cd gopath/"src/golang.org/x/tools/cmd/stringer" do
      system "go", "install"
    end

    cd gopath/"src/github.com/mitchellh/gox" do
      system "go", "install"
    end

    cd gopath/"src/github.com/hashicorp/otto" do
      system "make", "dev"
      bin.install "bin/otto"
    end
  end

  test do
    system "#{bin}/otto", "status"
  end
end
