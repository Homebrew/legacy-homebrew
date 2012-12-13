require 'formula'

class Pce < Formula
  homepage 'http://www.hampa.ch/pce/'
  url 'http://www.hampa.ch/pub/pce/pce-0.2.1.tar.gz'
  sha1 '72b9de82fc966a0ba037002605df7fbb7c7f5fb3'

  head 'git://git.hampa.ch/pce.git'

  devel do
    url 'http://www.hampa.ch/pub/pce/pre/pce-20120904-92b57a0.tar.gz'
    sha1 '577f5ad48e9b65ff01b8a6be655c83e3fda0a778'
  end

  depends_on 'sdl'
  depends_on 'readline'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--enable-readline"
    system "make"

    # We need to run 'make install' without parallelization, because
    # of a race that may cause the 'install' utility to fail when
    # two instances concurrently create the same parent directories.
    ENV.deparallelize
    system "make install"
  end

  def test
    system "#{bin}/pce-ibmpc -V"
  end
end
