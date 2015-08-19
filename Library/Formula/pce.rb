class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
  sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"

  head "git://git.hampa.ch/pce.git"

  devel do
    url "http://www.hampa.ch/pub/pce/pre/pce-20140222-4b05f0c.tar.gz"
    sha256 "44edaf071bb6840b6b3336174d528ff10c4dba8cb38194f0289fda81ac34f57f"
  end

  depends_on "sdl"
  depends_on "readline"

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
    system "make", "install"
  end

  test do
    system "#{bin}/pce-ibmpc", "-V"
  end
end
