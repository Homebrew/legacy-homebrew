class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "https://download.gimp.org/pub/babl/0.1/babl-0.1.16.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/babl/babl_0.1.16.orig.tar.bz2"
  sha256 "7d6ba55ec53ee6f6bf6945beec28839d09ff72376f4d83035eb379cd4f3e980e"

  bottle do
    sha256 "b6eaf46444795d0f3ad5f6dae51212403057baca537912d53c5b65ff87f9e694" => :el_capitan
    sha256 "a47b7f4832814eb4effdf8b11fd5763f48ae6ab330e823dfd88b55923fa33c05" => :yosemite
    sha256 "94cb19207e867b58f77fe6c2ba3629a6595a994722840ad657c5461743b5f2ac" => :mavericks
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

  if build.universal?
    fails_with :gcc_4_0
    fails_with :gcc
    ("4.3".."5.1").each do |n|
      fails_with :gcc => n
    end
  end

  def install
    ENV.universal_binary if build.universal?
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
