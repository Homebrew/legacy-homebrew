require 'formula'

class Rzip <Formula
  url 'http://rzip.samba.org/ftp/rzip/rzip-2.1.tar.gz'
  homepage 'http://rzip.samba.org/'
  md5 '0a3ba55085661647c12f2b014c51c406'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", 
           "--prefix=#{prefix}", "--mandir=#{man}"

    # --mandir doesn't seem to do anything, so we need to modify the
    # Makefile ourselves
    inreplace "Makefile", /^INSTALL_MAN=.+$/, "INSTALL_MAN=#{man}"

    system "make install"

    # Make symlinks for `runzip`
    File.symlink bin+'rzip', bin+'runzip'
    File.symlink man1+'rzip.1', man1+'runzip.1'
  end
end
