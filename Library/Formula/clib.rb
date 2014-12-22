class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.4.1.tar.gz"
  sha1 "f1d5dbd76d8ad75204d182f9db1b197e311fa25e"

  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any
    sha1 "3c00a49b63b1aebd8455fcc4294910c619df0539" => :yosemite
    sha1 "54593525512d3d10f18fcac29e8fece198242f75" => :mavericks
    sha1 "9ff299d4acd909c7087237788c8dff55a4247ea4" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
