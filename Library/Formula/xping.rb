require "formula"

class Xping < Formula

  homepage "http://github.com/martintopholm/xping"
  version "1.3"
  depends_on "libevent"

  stable do
    url "https://github.com/martintopholm/xping/archive/v#{version}.tar.gz"
    sha1 "822cd76851af577d2b987dd65933ca9187a4ea8f"
    patch do
      url "http://martin.topholm.eu/pub/xping/brew/0001-main-keep-env-cflags-and-clear-install-deps.patch"
      sha1 "c52dd1d313a0b0f8055f0669effbddf14cae067e"
    end
    patch do
      url "http://martin.topholm.eu/pub/xping/brew/0003-termio-correct-labelwidth-variable-scope.patch"
      sha1 "dfac12bbf127aad28ed9702c5d08ecd3996256a6"
    end
  end
  head do
    url "https://github.com/martintopholm/xping.git", :using => :git, :branch => "master"
  end

  def install
    ENV.append "DEPS", "check-curses.c"
    ENV.append "CFLAGS", "-DNCURSES"
    ENV.append "LIBS", "-lncurses"
    system "make"
    system "make install PREFIX=#{prefix} MANPATH=#{prefix}/share/man"
  end

  test do
    system "#{bin}/xping -V"
  end

  def caveats; <<-EOS.undent
    xping requires superuser privileges. You can either run the program
    via `sudo`, or change its ownership to root and set the setuid bit:

      sudo chown root:wheel #{bin}/xping
      sudo chmod u+s #{bin}/xping

    In any case, you should be certain that you trust the software you
    are executing with elevated privileges.
    EOS
  end

end
