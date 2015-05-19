class Cogl < Formula
  desc "Low level OpenGL abstraction library developed for Clutter"
  homepage "https://developer.gnome.org/cogl/"
  url "https://download.gnome.org/sources/cogl/1.20/cogl-1.20.0.tar.xz"
  sha256 "729e35495829e7d31fafa3358e47b743ba21a2b08ff9b6cd28fb74c0de91192b"

  bottle do
    sha256 "16b476d5d5d34c5dadd575e7ae9e6b526043083d574eadb92ae11f1642dc6fab" => :yosemite
    sha256 "9071de70236e6d6a3b3357e20734200895bf2a2bb280493f9a9da716e3c04bb8" => :mavericks
    sha256 "faa1b4a195de1c6308d59c63061717244d529a53589d7e7e6d65e1cae9aa88bc" => :mountain_lion
  end

  head do
    url "https://git.gnome.org/browse/cogl", :using => :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk-doc"
  depends_on "pango"

  depends_on :x11 => ["2.5.1", :recommended]
  deprecated_option "without-x" => "without-x11"

  # Lion's grep fails, which later results in compilation failures:
  # libtool: link: /usr/bin/grep -E -e [really long regexp] ".libs/libcogl.exp" > ".libs/libcogl.expT"
  # grep: Regular expression too big
  if MacOS.version == :lion
    resource "grep" do
      url "http://ftpmirror.gnu.org/grep/grep-2.20.tar.xz"
      mirror "https://ftp.gnu.org/gnu/grep/grep-2.20.tar.xz"
      sha256 "f0af452bc0d09464b6d089b6d56a0a3c16672e9ed9118fbe37b0b6aeaf069a65"
    end
  end

  def install
    # Don't dump files in $HOME.
    ENV["GI_SCANNER_DISABLE_CACHE"] = "yes"

    if MacOS.version == :lion
      resource("grep").stage do
        system "./configure", "--disable-dependency-tracking",
               "--disable-nls",
               "--prefix=#{buildpath}/grep"
        system "make", "install"
        ENV["GREP"] = "#{buildpath}/grep/bin/grep"
      end
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-cogl-pango=yes
      --enable-introspection=yes
      --disable-glx
    ]
    args << "--without-x" if build.without? "x11"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
    doc.install "examples"
  end
  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <cogl/cogl.h>

      int main()
      {
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/cogl",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
