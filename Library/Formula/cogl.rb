class Cogl < Formula
  desc "Low level OpenGL abstraction library developed for Clutter"
  homepage "https://developer.gnome.org/cogl/"
  url "https://download.gnome.org/sources/cogl/1.22/cogl-1.22.0.tar.xz"
  sha256 "689dfb5d14fc1106e9d2ded0f7930dcf7265d0bc84fa846b4f03941633eeaa91"

  bottle do
    sha256 "40e791051fe658bfef8c3fd931871e2ed3d5574b99e174eba6f0adeb514328a3" => :el_capitan
    sha256 "8468cc80cc507b84f176286d86e143e319b0b34c50d34f8b626c36a95f670215" => :yosemite
    sha256 "ba4d3405e3b3af0b4e40565bae7c84e72b8fe6b96e1aa26567d3c6d77a5f7904" => :mavericks
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
      --without-x
    ]

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
