require "language/go"

class Termshare < Formula
  desc "Interactive or view-only terminal sharing via client or web"
  homepage "https://termsha.re"
  url "https://github.com/progrium/termshare/archive/v0.2.0.tar.gz"
  sha256 "fa09a5492d6176feff32bbcdb3b2dc3ff1b5ab2d1cf37572cc60eb22eb531dcd"
  revision 1

  head "https://github.com/progrium/termshare.git"

  bottle do
    sha256 "cdc5aa1875729ba51f995d7e658f4d800e2d50b4dd4d3dc166236b930b6931dc" => :mavericks
    sha256 "c0d1f30479a2e629aa892b6e3be5b053c7855e387d93b430a6d09207d81edbab" => :mountain_lion
    sha256 "fb308a82ab7b257b107e32d52930d8db05888a097ea9c33696287f56aafaaf9f" => :lion
  end

  depends_on "go" => :build
  depends_on :hg => :build

  go_resource "code.google.com/p/go.net" do
    url "https://code.google.com/p/go.net",
    :using => :hg,
    :revision => "937a34c9de13"
  end

  go_resource "github.com/heroku/hk" do
    url "https://github.com/heroku/hk.git",
    :revision => "406190e9c93802fb0a49b5c09611790aee05c491"
  end

  go_resource "github.com/kr/pty" do
    url "https://github.com/kr/pty.git",
    :revision => "f7ee69f31298ecbe5d2b349c711e2547a617d398"
  end

  go_resource "github.com/nu7hatch/gouuid" do
    url "https://github.com/nu7hatch/gouuid.git",
    :revision => "179d4d0c4d8d407a32af483c2354df1d2c91e6c3"
  end

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/progrium/termshare"
    path.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      system "go", "build", "-o", "termshare"
      bin.install "termshare"
    end
  end

  test do
    system "#{bin}/termshare", "-v"
  end
end
