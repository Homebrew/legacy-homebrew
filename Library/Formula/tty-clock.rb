require 'formula'

class TtyClock < Formula
  homepage 'https://github.com/xorg62/tty-clock/tree/d9875dca06a995faf56a5816abbc5c7ba8c45970'
  url 'https://github.com/xorg62/tty-clock.git', :using => :git, :revision => 'd9875dca06a995faf56a5816abbc5c7ba8c45970'
  sha1 'd9875dca06a995faf56a5816abbc5c7ba8c45970'

  def install
	inreplace "Makefile", "/usr/local/bin/", "#{prefix}/bin/"
	system "make"
	system "make install"
  end

  test do
    system "#{bin}/tty-clock"
  end
end
