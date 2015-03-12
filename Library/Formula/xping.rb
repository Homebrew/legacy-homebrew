class Xping < Formula
  homepage "https://github.com/martintopholm/xping"

  depends_on "libevent"

  stable do
    url "https://github.com/martintopholm/xping/archive/v1.3.tar.gz"
    sha256 "6bab7abf5433fd1daa7de939727db95f88a2ac3630f92ec2f55cfae9d69846e5"

    # patches waiting for upstream release tag
    patch do
      url "http://martin.topholm.eu/pub/xping/brew/0001-main-keep-env-cflags-and-clear-install-deps.patch"
      sha256 "50455e4d6ca14f8e7264bcc5b5b71226f149e082e2944901cec3958cac7249d6"
    end

    patch do
      url "http://martin.topholm.eu/pub/xping/brew/0003-termio-correct-labelwidth-variable-scope.patch"
      sha256 "dc3a0b7ad9f0031fead8f41cd59ed338bb701ef1615985f84388b0587229189c"
    end
  end

  head do
    url "https://github.com/martintopholm/xping.git", :branch => "master"
  end

  def install
    # Terminal.app doesn't play well with ANSI sequences.
    # Link against NCURSES instead.
    ENV.append "DEPS", "check-curses.c"
    ENV.append "CFLAGS", "-DNCURSES"
    ENV.append "LIBS", "-lncurses"
    system "make"
    system "make", "install", "BINPATH=#{bin}", "MANPATH=#{man}"
  end

  test do
    # Non-setuid xping can't open raw socket and will return error.
    # Request version string instead.
    system "#{bin}/xping", "-V"
  end

  def caveats; <<-EOS.undent
    xping requires root privileges so you will need to run `sudo xping`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end
