require 'formula'

class Pce < Formula
  homepage 'http://www.hampa.ch/pce/'
  url 'http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz'
  sha1 'b12dffbacaad44532b5c576bcffae5d11f17cc56'

  head 'git://git.hampa.ch/pce.git'

  devel do
    url 'http://www.hampa.ch/pub/pce/pre/pce-20140222-4b05f0c.tar.gz'
    sha1 '980bf6cf02c074d3a70b9dbb262358e0518461b8'
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

  test do
    system "#{bin}/pce-ibmpc", "-V"
  end
end
