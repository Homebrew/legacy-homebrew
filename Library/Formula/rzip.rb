require 'formula'

class Rzip < Formula
  homepage 'http://rzip.samba.org/'
  url 'http://rzip.samba.org/ftp/rzip/rzip-2.1.tar.gz'
  sha1 'efeafc7a5bdd7daa0cea8d797ff21aa28bdfc8d9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # --mandir doesn't seem to do anything, so we need to modify the
    # Makefile ourselves
    inreplace "Makefile", /^INSTALL_MAN=.+$/, "INSTALL_MAN=#{man}"

    system "make install"

    # Make symlinks for `runzip`
    File.symlink bin+'rzip', bin+'runzip'
    File.symlink man1+'rzip.1', man1+'runzip.1'
  end
end
