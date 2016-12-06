require 'formula'

class Libeio < Formula
  homepage 'http://software.schmorp.de/pkg/libeio.html'
  head 'cvs://:pserver:anonymous@cvs.schmorp.de:/schmorpforge:libeio'

  # These are needed for the autoreconf it always tries to run.
  depends_on :automake
  depends_on :libtool

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
