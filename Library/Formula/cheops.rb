require 'formula'

class Cheops < Formula
  url 'http://files.nothingisreal.com/software/cheops/cheops-1.1.tar.bz2'
  homepage 'http://en.nothingisreal.com/wiki/CHEOPS'
  md5 'ced2dba9d0d6de77d538e04ff2909969'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
