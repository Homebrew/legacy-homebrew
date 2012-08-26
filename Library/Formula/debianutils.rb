require 'formula'

class Debianutils < Formula
  homepage 'http://anonscm.debian.org/gitweb/?p=users/clint/debianutils.git'
<<<<<<< HEAD
  url 'http://ftp.de.debian.org/debian/pool/main/d/debianutils/debianutils_4.3.2.tar.gz'
  sha1 '704a33c90d4f74fa03e4e649737f89fcad53bee8'
=======
  url 'http://ftp.de.debian.org/debian/pool/main/d/debianutils/debianutils_4.3.3.tar.gz'
  sha1 'c1e8427552f7a37deeedf50e9f6a529342cc3e81'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

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
