class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.7.0.tar.gz"
  sha256 "6711fe924833919d53c1dfbbb43f3777d33e20357a1b1536c4472f6a1b3c6be0"
  head "https://github.com/KittyKatt/screenFetch.git", :shallow => false

  bottle do
    cellar :any
    sha256 "f06711aa9632682d30fc81ecec15eb9822ed1946fa39880ba18a9d57a27c66d9" => :yosemite
    sha256 "ec75963396cf12dfd7277d6149a2aa87dd63079ddaccb2a03fd04e55f163e36b" => :mavericks
    sha256 "16810381df9a010c1c5c84dd1eba262e4e7b276a3e12ca87d5d0e2e3302545bd" => :mountain_lion
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
