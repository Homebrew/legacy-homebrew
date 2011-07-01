require 'formula'

class Lrzsz < Formula
  url 'http://www.ohse.de/uwe/releases/lrzsz-0.12.20.tar.gz'
  homepage 'http://www.ohse.de/uwe/software/lrzsz.html'
  md5 'b5ce6a74abc9b9eb2af94dffdfd372a4'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    # there's a bug in lrzsz when using custom --prefix
    # must install the binaries manually first
    bin.install "src/lrz"
    bin.install "src/lsz"

    system "make install"
  end
end
