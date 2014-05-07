require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.1.5.tar.gz"
  sha1 "3e40fdd9dbd9092e74767e7cd62f94ffef65c915"

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
