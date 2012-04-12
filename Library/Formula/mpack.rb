require 'formula'

class Mpack < Formula
  url 'http://ftp.andrew.cmu.edu/pub/mpack/mpack-1.6.tar.gz'
  homepage 'http://ftp.andrew.cmu.edu/pub/mpack/'
  md5 'a70fa5afa76539a9afb70b9d81568fe8'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
