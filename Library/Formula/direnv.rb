class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "http://direnv.net"
  url "https://github.com/zimbatm/direnv/archive/v2.7.0.tar.gz"
  sha256 "3cfa8f41e740c0dc09d854f3833058caec0ea0d67d19e950f97eee61106b0daf"

  head "https://github.com/zimbatm/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20345349318934e2ba44d5109872a0e51ae69d09306727cfd88a45597eda27c0" => :el_capitan
    sha256 "13c1d2a2b34eab4f755a47235f85fd02c7cbd65d0bcb5bd01de0e69d1f28cb38" => :yosemite
    sha256 "8c32edd5768f78b31308f382d07237c17ea9e664da9b2ad5613fd564d271fb28" => :mavericks
    sha256 "a7fd223871f2e8ddbf4b797e13527400a27207c9c8ace2b5c995c931a0e70a33" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  def caveats
    "Finish setup by following: https://github.com/zimbatm/direnv#setup"
  end

  test do
    system bin/"direnv", "status"
  end
end
