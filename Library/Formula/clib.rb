class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.4.2.tar.gz"
  sha256 "c1f3d98a10955a4ce6c2c100b1ffd341d5e99dcf6e642793d3bfa4ff4a431e13"

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
