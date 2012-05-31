require 'formula'

class Ledit < Formula
  url 'http://pauillac.inria.fr/~ddr/ledit/distrib/src/ledit-2.01.tgz'
  homepage 'http://pauillac.inria.fr/~ddr/ledit/'
  md5 '24faa563dff1091aea2e744b1ec15fbb'

  depends_on 'objective-caml'
  depends_on 'camlp5'

  def install
    # like camlp5, this build fails if the jobs are parallelized
    ENV.deparallelize
    args = %W[BINDIR=#{bin} LIBDIR=#{lib} MANDIR=#{man}]
    system "make", *args
    system "make", "install", *args
  end
end
