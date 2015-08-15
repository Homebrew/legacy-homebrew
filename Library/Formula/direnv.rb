class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "http://direnv.net"
  url "https://github.com/zimbatm/direnv/archive/v2.7.0.tar.gz"
  sha256 "3cfa8f41e740c0dc09d854f3833058caec0ea0d67d19e950f97eee61106b0daf"

  head "https://github.com/zimbatm/direnv.git"

  bottle do
    cellar :any
    sha1 "0cee43bd9df0e2f376e6edfaaebb6ca537df0692" => :yosemite
    sha1 "9d0cd4d5ec285daba2d2e4237cac58e963fd88fc" => :mavericks
    sha1 "26f4abf81efa2bcf23ae58c0a913ac6b93ef3f1d" => :mountain_lion
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
