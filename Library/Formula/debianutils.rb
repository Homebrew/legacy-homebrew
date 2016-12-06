require 'formula'

# This formula will install run-parts(8), ischroot(1) and tempfile(1)
class Debianutils < Formula
  homepage 'http://anonscm.debian.org/gitweb/?p=users/clint/debianutils.git'
  version '4.3'
  # debian version is already autotools bootstraped.
  url 'http://ftp.de.debian.org/debian/pool/main/d/debianutils/debianutils_4.3.tar.gz'
  md5 'a34339267e157e71f62ac8f0bc40c473'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # some commands are Debian Linux specific and we don't want them.
    bin.install 'run-parts', 'ischroot', 'tempfile'
    man1.install 'ischroot.1', 'tempfile.1'
    man8.install 'run-parts.8'
  end

  def test
    system "#{bin}/run-parts --version"
    system "#{bin}/ischroot --version"
    system "#{bin}/tempfile --version"
  end
end
