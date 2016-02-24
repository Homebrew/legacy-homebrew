class Jbigkit < Formula
  desc "JBIG1 data compression standard implementation"
  homepage "https://www.cl.cam.ac.uk/~mgk25/jbigkit/"
  url "https://www.cl.cam.ac.uk/~mgk25/jbigkit/download/jbigkit-2.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/j/jbigkit/jbigkit_2.1.orig.tar.gz"
  sha256 "de7106b6bfaf495d6865c7dd7ac6ca1381bd12e0d81405ea81e7f2167263d932"

  bottle do
    cellar :any
    sha256 "764396342e87b84253aa06f5046f90c778cacca998ce970900cb2fdf1cfdc3fa" => :yosemite
    sha256 "0ce925915b984307d2e679622138143c5cc5baf832b0a16003fa1e6111a5df9f" => :mavericks
    sha256 "0afb6297101bc3269f0ebca1590cda66a62cbd90e3fdbec38dc011131711d32b" => :mountain_lion
  end

  head "https://www.cl.cam.ac.uk/~mgk25/git/jbigkit",
       :using => :git

  option :universal
  option "with-test", "Verify the library during install"

  deprecated_option "with-check" => "with-test"

  def install
    # Set for a universal build and patch the Makefile.
    # There's no configure. It creates a static lib.
    ENV.universal_binary if build.universal?
    system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}"

    if build.with? "test"
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
