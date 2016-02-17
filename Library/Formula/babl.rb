class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.16.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/babl/babl_0.1.16.orig.tar.bz2"
  sha256 "7d6ba55ec53ee6f6bf6945beec28839d09ff72376f4d83035eb379cd4f3e980e"

  bottle do
    sha256 "7f5aacab0effd76ebb60e3057f5a620570e2cafa41017617f60b3d666be1e633" => :el_capitan
    sha256 "dd3073278a5a7f3e584e37cfcd2fb5268a98b3230d16b125aec806a5968668f4" => :yosemite
    sha256 "060bc343437aeff92ed1f411c4d4e98f5cb0577494eb8e55b2398f398071bf1a" => :mavericks
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
