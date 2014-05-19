require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.1.6.tar.gz"
  sha1 "6b9711b594f3aff8c4a8a4aefac926c8d0f8555c"

  bottle do
    cellar :any
    sha1 "901a3a1cb827cdf281cb95dc3305f078907fb1bc" => :mavericks
    sha1 "7fae6bf0e58988a8778626a68618f8e067eaf13d" => :mountain_lion
    sha1 "c4bb71886255f81fcf112ca5e7b65d6f9dee66fb" => :lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
