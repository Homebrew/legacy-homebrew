class Babl < Formula
  desc "Dynamic, any-to-any, pixel format translation library"
  homepage "http://www.gegl.org/babl/"
  url "http://download.gimp.org/pub/babl/0.1/babl-0.1.12.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/babl/babl_0.1.12.orig.tar.bz2"
  sha256 "2f802b7f1a17b72c10bf0fe1e69b7a888cf7ce62b7cf1537b030f7f88d55a407"

  bottle do
    sha1 "d3ead1808b7c029ab864d3318d7009379cc205a5" => :yosemite
    sha1 "4fcb4a9c92b59796d40ffc4312935ca756d5264f" => :mavericks
    sha1 "a35994e97093d303d02d30c3369bccfd1f33af37" => :mountain_lion
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
