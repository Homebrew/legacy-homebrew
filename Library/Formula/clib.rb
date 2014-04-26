require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.1.4.tar.gz"
  sha1 "b096b9a3dba3583519756b01c02b705468beb8ff"

  bottle do
    cellar :any
    sha1 "3eebb30b13ab082550e5c2a3ec559553bad913cb" => :mavericks
    sha1 "17d2da57c3e83d5b99b9eff16ed58160fdba028a" => :mountain_lion
    sha1 "04c4d4f6e42d1057991a4af18f304fb81cc114b2" => :lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
