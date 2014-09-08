require 'formula'

class Httping < Formula
  homepage 'http://www.vanheusden.com/httping/'
  url 'http://www.vanheusden.com/httping/httping-2.3.4.tgz'
  sha1 '5306d9b56ea89f7c39ee4729c2bbb6d0d867f310'

  depends_on 'gettext'
  depends_on 'fftw' => :optional

  def install
    # Reported upstream, see: https://github.com/Homebrew/homebrew/pull/28653
    inreplace %w{configure Makefile}, "ncursesw", "ncurses"
    ENV.append "LDFLAGS", "-lintl"
    inreplace "Makefile", "cp nl.mo $(DESTDIR)/$(PREFIX)/share/locale/nl/LC_MESSAGES/httping.mo", ""
    system "make", "install", "PREFIX=#{prefix}"
  end
end
