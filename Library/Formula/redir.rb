class Redir < Formula
  homepage "http://sammy.net/~sammy/hacks/"
  url "https://github.com/TracyWebTech/redir/archive/2.2.1-9.tar.gz"
  version "2.2.1_9"
  sha1 "84ae75104d79432bbc15f67e4dc2980e0912b2b6"

  depends_on "cmake" => :build

  def install
    system "make"
    system "install -d #{prefix}/bin #{man}/man1"
    system "install redir #{prefix}/bin/redir"
    system "install redir.man #{man}/man1/redir.1"
  end
end
