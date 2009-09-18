require 'brewkit'

class GnuTar < Formula
  @url='ftp://ftp.gnu.org/gnu/tar/tar-1.22.tar.gz'
  @homepage='http://www.gnu.org/software/tar/'
  @md5='efafad1b256e3de410f4fce5335d9c9d'

  def install
    system "./configure", "--prefix='#{prefix}'",
                          "--program-prefix=g",
                          "--mandir='#{man}'"
    system "make install"
  end
end
