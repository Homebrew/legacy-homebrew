require 'formula'

class Logcheck < Formula
  homepage 'http://logcheck.alioth.debian.org/'
  url 'http://ftp.de.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.16.tar.xz'
  sha1 '27892a6abf3822d285efbb26f935d80762134679'

  def install
    system "make", "install",
                   "--always-make",
                   "DESTDIR=#{prefix}",
                   "SBINDIR=sbin",
                   "BINDIR=bin"
  end

  test do
    system "#{sbin}/logtail", "-f", "#{HOMEBREW_REPOSITORY}/README.md"
  end
end
