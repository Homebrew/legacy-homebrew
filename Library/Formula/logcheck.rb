require 'formula'

class Logcheck < Formula
  homepage 'http://logcheck.org/'
  url 'http://ftp.de.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.14.tar.gz'
  md5 'cbd32dbdcb877f267636205f33ede790'

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
