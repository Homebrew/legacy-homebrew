class Gexiv2 < Formula
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.2.tar.xz"
  sha256 "2fd21f0ed5125e51d02226e7f41be751cfa8ae411a8ed1a651e16b06d79047b2"

  bottle do
    cellar :any
    sha256 "2919516539dca1635b6e680c9065ee6617b497a0c38d0268433d47e0a6e17365" => :yosemite
    sha256 "10edd0c5a927dfeb9e2a6c3dcae5c64fc36f817cd701bcaf36b41b78c42d4370" => :mavericks
    sha256 "76c9f4629361d6409775d40276cf868216cbf0fbc8f061fc1bc208e73eab3509" => :mountain_lion
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
