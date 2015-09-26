class Netpbm < Formula
  desc "Image manipulation"
  homepage "http://netpbm.sourceforge.net"
  # Maintainers: Look at http://netpbm.svn.sourceforge.net/viewvc/netpbm/
  # for versions and matching revisions
  url "http://svn.code.sf.net/p/netpbm/code/advanced", :revision => 2294
  version "10.68"

  head "http://svn.code.sf.net/p/netpbm/code/trunk"

  bottle do
    cellar :any
    revision 2
    sha256 "ad369fbec6067be0355b02aa02f5b542224cbf9835974de7d0d36ea2a1966e2f" => :el_capitan
    sha1 "1f842e7b6c2632a80401751a5975f3379af6a10e" => :yosemite
    sha1 "b2ee77e9829b27ef530c7ebc50043e4d5bc23b8e" => :mavericks
    sha1 "a036886a7d91d2658ac1dd76ed6bc9cc246e3ec6" => :mountain_lion
  end

  option :universal

  depends_on "libtiff"
  depends_on "jasper"
  depends_on "libpng"

  def install
    ENV.universal_binary if build.universal?

    cp "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
      s.change_make_var! "NETPBMLIBTYPE", "dylib"
      s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
      s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{Formula["jasper"].opt_include}/jasper"
    end

    ENV.deparallelize
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"

    cd "stage" do
      inreplace "pkgconfig_template" do |s|
        s.gsub! "@VERSION@", File.read("VERSION").sub("Netpbm ", "").chomp
        s.gsub! "@LINKDIR@", lib
        s.gsub! "@INCLUDEDIR@", include
      end

      prefix.install %w[bin include lib misc]
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir["man/man1/*.1"]
      man5.install Dir["man/man5/*.5"]
      lib.install Dir["link/*.a"]
      (lib/"pkgconfig").install "pkgconfig_template" => "netpbm.pc"
    end

    (bin/"doc.url").unlink
  end

  test do
    system ("#{bin}/pngtopam #{test_fixtures("test.png")} -alphapam >> test.pam")
    system "#{bin}/pamdice", "test.pam", "-outstem", "#{testpath}/testing"
    assert File.exist?("testing_0_0.")
  end
end
