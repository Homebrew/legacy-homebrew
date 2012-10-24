require 'formula'

class Debianutils < Formula
  homepage 'http://anonscm.debian.org/gitweb/?p=users/clint/debianutils.git'
  url 'http://ftp.de.debian.org/debian/pool/main/d/debianutils/debianutils_4.3.4.tar.gz'
  sha1 '18c5c50d330fb4b26b52d3dd6c6b8f3102eaa0ff'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install 'run-parts', 'ischroot', 'tempfile'
    man1.install 'ischroot.1', 'tempfile.1'
    man8.install 'run-parts.8'
  end
end
