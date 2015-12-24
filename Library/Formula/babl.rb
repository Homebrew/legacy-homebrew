class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.14.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/babl/babl_0.1.14.orig.tar.bz2"
  sha256 "e6dcb112c8f8f75471823fdcc5a6a65f753b4d0e96e377979ea01a5d6fad7d4f"

  bottle do
    sha256 "b839dc910c873b14e2c86466f3d3894c4349b8755a4231cad78e60ed85f7b4dd" => :el_capitan
    sha256 "db81183522e6d338475e43c2bed097b0ab5706eb24cc68c1889a673ca529e743" => :yosemite
    sha256 "8782f771f5efa9cbc5dcf09815b4cb078647477f56b2110e5c67517adeb5c8e3" => :mavericks
    sha256 "6e4ba55b1698c2edb1a006fbaa1bcaa72a8fc65007d86e21e022116a42a1bcae" => :mountain_lion
  end

  head do
    # Use Github instead of GNOME's git. The latter is unreliable.
    url "https://github.com/GNOME/babl.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build

  def install
    if build.universal?
      ENV.universal_binary
      opoo "Compilation may fail at babl-cpuaccel.c using gcc for a universal build" if ENV.compiler == :gcc
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <babl/babl.h>
      int main() {
        babl_init();
        const Babl *srgb = babl_format ("R'G'B' u8");
        const Babl *lab  = babl_format ("CIE Lab float");
        const Babl *rgb_to_lab_fish = babl_fish (srgb, lab);
        babl_exit();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/babl-0.1", "-L#{lib}", "-lbabl-0.1", testpath/"test.c", "-o", "test"
    system testpath/"test"
  end
end
