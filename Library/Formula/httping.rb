require 'formula'

class Httping < Formula
  homepage 'http://www.vanheusden.com/httping/'
  url 'http://www.vanheusden.com/httping/httping-2.3.3.tgz'
  sha1 '6b9e77039346388e2b02dbb1d60f7422e7133488'

  depends_on 'gettext'
  depends_on 'fftw' => :optional

  def install
    ENV.append "LDFLAGS", "-lintl"
    inreplace "Makefile", "cp nl.mo $(DESTDIR)/$(PREFIX)/share/locale/nl/LC_MESSAGES/httping.mo", ""
    system "make", "install", "PREFIX=#{prefix}"
  end
end
