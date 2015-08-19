class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "http://www.vanheusden.com/httping/"
  url "http://www.vanheusden.com/httping/httping-2.4.tgz"
  sha256 "dab59f02b08bfbbc978c005bb16d2db6fe21e1fc841fde96af3d497ddfc82084"

  head "https://github.com/flok99/httping.git"

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
