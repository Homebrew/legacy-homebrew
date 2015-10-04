class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.3.tar.xz"
  sha256 "390cfb966197fa9f3f32200bc578d7c7f3560358c235e6419657206a362d3988"
  revision 1

  bottle do
    sha256 "270b4350e13add5b48f08a9fa739b59a39efe29dac5ccc06fb2b063f8845787c" => :yosemite
    sha256 "dd5152129614cb1654578833d768b4bc39c24a55a49e3e528d1c32af30add549" => :mavericks
    sha256 "7faf7188a9bbbae5258108f6ed767fa9e32a183ba4c76aab596a90e428742192" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "gobject-introspection" => :build
  depends_on "glib"
  depends_on "exiv2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-introspection",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-L#{lib}",
      "-lgexiv2"
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
