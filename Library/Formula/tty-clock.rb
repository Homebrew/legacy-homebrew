require 'formula'

class TtyClock < Formula
  homepage 'https://github.com/xorg62/tty-clock'
  head 'https://github.com/xorg62/tty-clock.git'

  def install
    inreplace "Makefile", "/usr/local/bin/", "#{bin}"
    system "make"
    system "make install"
  end

  test do
    system "tty-clock"
  end
end
