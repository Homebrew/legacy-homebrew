class TtyClock < Formula
  desc "Analog clock in ncurses"
  homepage "https://github.com/xorg62/tty-clock"
  url "https://github.com/xorg62/tty-clock/archive/v0.1.tar.gz"
  sha256 "866ee25c9ef467a5f79e9560c8f03f2c7a4c0371fb5833d5a311a3103e532691"
  head "https://github.com/xorg62/tty-clock.git"

  def install
    inreplace "Makefile", "/usr/local/bin/", "#{bin}/"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/tty-clock -i"
  end
end
