class Termshare < Formula
  desc "Interactive or view-only terminal sharing via client or web"
  homepage "https://termsha.re"
  url "https://github.com/progrium/termshare/archive/v0.2.0.tar.gz"
  sha256 "fa09a5492d6176feff32bbcdb3b2dc3ff1b5ab2d1cf37572cc60eb22eb531dcd"

  head "https://github.com/progrium/termshare.git"

  bottle do
    sha256 "cdc5aa1875729ba51f995d7e658f4d800e2d50b4dd4d3dc166236b930b6931dc" => :mavericks
    sha256 "c0d1f30479a2e629aa892b6e3be5b053c7855e387d93b430a6d09207d81edbab" => :mountain_lion
    sha256 "fb308a82ab7b257b107e32d52930d8db05888a097ea9c33696287f56aafaaf9f" => :lion
  end

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install Go dependencies
    system "go", "get", "code.google.com/p/go.net/websocket"
    system "go", "get", "github.com/heroku/hk/term"
    system "go", "get", "github.com/kr/pty"
    system "go", "get", "github.com/nu7hatch/gouuid"

    # Build and install termshare
    system "go", "build", "-o", "termshare"
    bin.install "termshare"
  end

  test do
    system "#{bin}/termshare", "-v"
  end
end
