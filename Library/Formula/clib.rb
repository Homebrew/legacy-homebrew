class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.4.2.tar.gz"
  sha256 "c1f3d98a10955a4ce6c2c100b1ffd341d5e99dcf6e642793d3bfa4ff4a431e13"

  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any
    sha1 "f9d8fc54ec746beb253186b1cb8c30eee5f945d6" => :yosemite
    sha1 "82d7f283b9c85566f3e1a7337ec998cc11406c66" => :mavericks
    sha1 "602d091a1490a683a0e07e71df7c26ecf430e353" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
