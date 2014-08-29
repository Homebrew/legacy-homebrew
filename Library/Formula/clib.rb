require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.2.2.tar.gz"
  sha1 "e103638102f33cb38308d6f108feea9f0daff08a"

  bottle do
    cellar :any
    sha1 "078a75c4851fd7baef7dc1b44b2573c873d61ef4" => :mavericks
    sha1 "3b694a2c43b542317795383df940404edf91ada9" => :mountain_lion
    sha1 "2551a74714e88fe36b44132ab9b9f55554c12cd8" => :lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
