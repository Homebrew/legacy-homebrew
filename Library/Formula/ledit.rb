require 'formula'

class Ledit < Formula
  homepage 'http://pauillac.inria.fr/~ddr/ledit/'
  url 'http://pauillac.inria.fr/~ddr/ledit/distrib/src/ledit-2.03.tgz'
  sha1 '8fef728f38e8d6fc30dd5f71dd5b6b647212a43a'

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
