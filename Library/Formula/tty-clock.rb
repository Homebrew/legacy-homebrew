require 'formula'

class TtyClock < Formula
  desc "Analog clock in ncurses"
  homepage 'https://github.com/xorg62/tty-clock'
  url 'https://github.com/xorg62/tty-clock/archive/v0.1.tar.gz'
  sha1 '5350a9c6c391f8a87fd8f467ca3aeb932585e69e'
  head 'https://github.com/xorg62/tty-clock.git'

  def install
    inreplace "Makefile", "/usr/local/bin/", "#{bin}/"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/tty-clock -i"
  end
end
