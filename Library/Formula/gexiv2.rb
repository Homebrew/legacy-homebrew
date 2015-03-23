class Gexiv2 < Formula
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.2.tar.xz"
  sha256 "2fd21f0ed5125e51d02226e7f41be751cfa8ae411a8ed1a651e16b06d79047b2"

  bottle do
    cellar :any
    revision 1
    sha256 "72c027a1e3b4b423092b1105c2eed70411e33e91571e204e69a5e0f7af3a600a" => :yosemite
    sha256 "567a7706ae08b6eb191c7eeb16be8f599e2fce179dc32a5144b717357b60a221" => :mavericks
    sha256 "aaa95aba6a40f5207c7140f56f6dfb43e9a54eb81292f8a1be16d329fc475693" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "exiv2"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
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
      "-lgexiv2",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
