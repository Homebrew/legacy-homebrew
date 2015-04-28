class Jbigkit < Formula
  homepage "https://www.cl.cam.ac.uk/~mgk25/jbigkit/"
  url "https://www.cl.cam.ac.uk/~mgk25/jbigkit/download/jbigkit-2.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/j/jbigkit/jbigkit_2.1.orig.tar.gz"
  sha256 "de7106b6bfaf495d6865c7dd7ac6ca1381bd12e0d81405ea81e7f2167263d932"

  head "https://www.cl.cam.ac.uk/~mgk25/git/jbigkit",
       :using => :git

  option :universal
  option "with-check", "Verify the library during install"

  def install
    # Set for a universal build and patch the Makefile.
    # There's no configure. It creates a static lib.
    ENV.universal_binary if build.universal?
    system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}"

    if build.with? "check"
      # It needs j1 to make the tests happen in sequence.
      ENV.deparallelize
      system "make", "test"
    end

    cd "pbmtools" do
      bin.install %w[pbmtojbg jbgtopbm pbmtojbg85 jbgtopbm85]
      man1.install %w[pbmtojbg.1 jbgtopbm.1]
      man5.install %w[pbm.5 pgm.5]
    end
    cd "libjbig" do
      lib.install Dir["lib*.a"]
      (prefix/"src").install Dir["j*.c", "j*.txt"]
      include.install Dir["j*.h"]
    end
    (share/"jbigkit").install "examples", "contrib"
  end

  test do
    system "#{bin}/jbgtopbm #{share}/jbigkit/examples/ccitt7.jbg | #{bin}/pbmtojbg - testoutput.jbg"
    system "/usr/bin/cmp", share/"jbigkit/examples/ccitt7.jbg", "testoutput.jbg"
  end
end
