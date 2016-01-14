require "language/go"

class Termshare < Formula
  desc "Interactive or view-only terminal sharing via client or web"
  homepage "https://termsha.re"
  url "https://github.com/progrium/termshare/archive/v0.2.0.tar.gz"
  sha256 "fa09a5492d6176feff32bbcdb3b2dc3ff1b5ab2d1cf37572cc60eb22eb531dcd"
  revision 1

  head "https://github.com/progrium/termshare.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d56c348b2700fb6abca76f2aa5f9414a3aed51a54176d6beeb5cc7d70ccaf9aa" => :el_capitan
    sha256 "bf014af5e9a131d751e4b77b15dfbc4a77c4eeda2a05f51795878d04f90c04fb" => :yosemite
    sha256 "fc339f6cc68ee5f9a712e26a59333dd7d74fa44a666395c9c433125979318f14" => :mavericks
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
