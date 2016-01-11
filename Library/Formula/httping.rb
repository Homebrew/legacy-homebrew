class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://www.vanheusden.com/httping/"
  url "https://www.vanheusden.com/httping/httping-2.4.tgz"
  sha256 "dab59f02b08bfbbc978c005bb16d2db6fe21e1fc841fde96af3d497ddfc82084"

  head "https://github.com/flok99/httping.git"

  bottle do
    cellar :any
    sha256 "ea7f2e1239508263e5bdb94feb32d0831e3df6c2d2224b7eebf00f791cab52f5" => :el_capitan
    sha256 "e248a4e6f8d3dc107db198093952ee3458ab1c6cb3dbd67d6d43723379fc7ba2" => :yosemite
    sha256 "7be244fea2e97efea922a8f5750e739fc79ed13c9f9c69788e38672383197098" => :mavericks
  end

  depends_on "gettext"
  depends_on "fftw" => :optional

  def install
    # Reported upstream, see: https://github.com/Homebrew/homebrew/pull/28653
    inreplace %w[configure Makefile], "ncursesw", "ncurses"
    ENV.append "LDFLAGS", "-lintl"
    inreplace "Makefile", "cp nl.mo $(DESTDIR)/$(PREFIX)/share/locale/nl/LC_MESSAGES/httping.mo", ""
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"httping", "-c", "2", "-g", "http://brew.sh"
  end
end
