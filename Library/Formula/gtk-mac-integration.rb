require "formula"

class GtkMacIntegration < Formula
  homepage "https://wiki.gnome.org/Projects/GTK+/OSX/Integration"
  url "https://git.gnome.org/browse/gtk-mac-integration/snapshot/gtk-mac-integration-2.0.5.tar.gz"
  sha1 "3b48e85e484b595718c869ac5af6e315f64449d6"

  depends_on "gtk+"
  depends_on "glib"
  depends_on "gtk-doc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :x11

  option :universal

  def install
    ENV["LIBTOOL"] = "glibtool"
    ENV["LIBTOOLIZE"] = "glibtoolize"
    ENV.universal_binary if build.universal?
    inreplace 'autogen.sh', 'libtoolize', 'glibtoolize'

    system "./autogen.sh" , "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
    system "make", "install"
  end
end
