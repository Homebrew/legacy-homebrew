require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.1.2.tar.gz"
  sha1 "5faace8b907e882293ed5ccbe17ce222d9013694"

  bottle do
    cellar :any
    sha1 "a6697350e19e0ce6102381d4d8a18868655ce19d" => :mavericks
    sha1 "42627582b910bdf6348beffbbbf02cf1856ea7aa" => :mountain_lion
    sha1 "3e1a8fc43c719a55e3ad0a9e9bab1740aefe3fd6" => :lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
