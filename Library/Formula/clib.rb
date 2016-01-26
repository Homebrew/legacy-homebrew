class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.7.0.tar.gz"
  sha256 "08a342769399525814f74bf989e33d6b416cfd99ee2e4238738ab1187fa27fbb"

  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any
    sha256 "c7566b4ab3995cd6f459f468f8de80157cf7b231e09f252310b025a93db34db0" => :yosemite
    sha256 "a5494bed819b037e2ae80aad74748954111e9598213056a1dabbe4d07fdee994" => :mavericks
    sha256 "e510d11ca3bebbd165dd3c102ed7c3329a917c293bc3aa8f2cb59eccc8bd3232" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
