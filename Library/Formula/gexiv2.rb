class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.3.tar.xz"
  sha256 "390cfb966197fa9f3f32200bc578d7c7f3560358c235e6419657206a362d3988"

  bottle do
    sha256 "c1d0a2a875a4a56d4b55c394be9a36edee091122c0ecb6008242c804e09c9002" => :yosemite
    sha256 "7d847194493085350fd821fbe50f1bec5e59a0c492175ed5681f89352d05c534" => :mavericks
    sha256 "70806647b07ca7c06a87fd44b1baaf7c89faedc4eddd8bf0abc8c742b98e665e" => :mountain_lion
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
      "-lgexiv2",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
