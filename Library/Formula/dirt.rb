class Dirt < Formula
  desc "Experimental sample playback"
  homepage "https://github.com/yaxu/Dirt"
  head "https://github.com/yaxu/Dirt.git"
  url "https://github.com/yaxu/Dirt/archive/1.0.tar.gz"
  sha256 "c7c51ea3f279c048e84d988978455f075fd8ae063b2ad7378fc9b8369218f8fb"

  depends_on "jack"
  depends_on "liblo"

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/dirt", "-h"
  end
end
