require 'formula'

class Logcheck < Formula
  homepage 'http://logcheck.org/'
  url 'http://ftp.de.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.15.tar.gz'
  sha1 'c1fef9d602f208e5cae64d39900834c216568fb0'

  def install
    system "make", "install",
                   "--always-make",
                   "DESTDIR=#{prefix}",
                   "SBINDIR=sbin",
                   "BINDIR=bin"
  end

  def test
    system "#{sbin}/logtail", "-f", "#{HOMEBREW_REPOSITORY}/README.md"
  end
end
