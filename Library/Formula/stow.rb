require 'formula'

class Stow < Formula
  homepage 'http://www.gnu.org/software/stow/'
  url 'http://ftpmirror.gnu.org/stow/stow-2.1.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/stow/stow-2.1.3.tar.gz'
  md5 'fbed3a8e3c57bb985566894deed335b7'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make install"
  end
end
