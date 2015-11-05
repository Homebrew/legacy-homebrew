class Glib < Formula
  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.46/glib-2.46.1.tar.xz"
  sha256 "5a1f03b952ebc3a7e9f612b8724f70898183e31503db329b4f15d07163c8fdfb"
  revision 1

  bottle do
    sha256 "99d0958231738f83acf2bf3e90202313ca1d082dede24253f33bf8aa50340cfc" => :el_capitan
    sha256 "bf8681c987aca26ecac56f2c620f289b04fb6760be6e5ad5c9ddd627318b68d9" => :yosemite
    sha256 "4852f170218d626aad387e1344cecedd74b0c9b0e8f0b61adf1ef44d3a6fafed" => :mavericks
  end

  option :universal
  option "with-test", "Build a debug build and run tests. NOTE: Not all tests succeed yet"

  deprecated_option "test" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libffi"

  fails_with :llvm do
    build 2334
    cause "Undefined symbol errors while linking"
  end

  resource "config.h.ed" do
    url "https://raw.githubusercontent.com/Homebrew/patches/eb51d82/glib/config.h.ed"
    version "111532"
    sha256 "9f1e23a084bc879880e589893c17f01a2f561e20835d6a6f08fcc1dad62388f1"
  end

  # https://bugzilla.gnome.org/show_bug.cgi?id=673135 Resolved as wontfix,
  # but needed to fix an assumption about the location of the d-bus machine
  # id file.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/59e4d32/glib/hardcoded-paths.diff"
    sha256 "a4cb96b5861672ec0750cb30ecebe1d417d38052cac12fbb8a77dbf04a886fcb"
  end

  # Fixes compilation with FSF GCC. Doesn't fix it on every platform, due
  # to unrelated issues in GCC, but improves the situation.
  # Patch submitted upstream: https://bugzilla.gnome.org/show_bug.cgi?id=672777
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/59e4d32/glib/gio.patch"
    sha256 "cc3f0f6d561d663dfcdd6154b075150f68a36f5a92f94e5163c1c20529bfdf32"
  end

  if build.universal?
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/59e4d32/glib/universal.patch"
      sha256 "7e1ad7667c7d89fcd08950c9c32cd66eb9c8e2ee843f023d1fadf09a9ba39fee"
    end
  end

  # Reverts GNotification support on OS X.
  # This only supports OS X 10.9, and the reverted commits removed the
  # ability to build glib on older versions of OS X.
  # https://bugzilla.gnome.org/show_bug.cgi?id=747146
  # Reverts upstream commits 36e093a31a9eb12021e7780b9e322c29763ffa58
  # and 89058e8a9b769ab223bc75739f5455dab18f7a3d, with equivalent changes
  # also applied to configure and gio/Makefile.in
  if MacOS.version < :mavericks
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/59e4d32/glib/gnotification-mountain.patch"
      sha256 "723def732304552ca55ae9f5b568ff3e8a59a14d512af72b6c1f0421f8228a68"
    end
  end

  def install
    ENV.universal_binary if build.universal?

    inreplace %w[gio/gdbusprivate.c gio/xdgmime/xdgmime.c glib/gutils.c],
      "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # renaming is necessary for patches to work
    mv "gio/gcocoanotificationbackend.c", "gio/gcocoanotificationbackend.m" unless MacOS.version < :mavericks
    mv "gio/gnextstepsettingsbackend.c", "gio/gnextstepsettingsbackend.m"

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    args = %W[
      --disable-maintainer-mode
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-dtrace
      --disable-libelf
      --enable-static
      --prefix=#{prefix}
      --localstatedir=#{var}
      --with-gio-module-dir=#{HOMEBREW_PREFIX}/lib/gio/modules
    ]

    system "./configure", *args

    if build.universal?
      buildpath.install resource("config.h.ed")
      system "ed -s - config.h <config.h.ed"
    end

    # disable creating directory for GIO_MOUDLE_DIR, we will do this manually in post_install
    inreplace "gio/Makefile", "$(mkinstalldirs) $(DESTDIR)$(GIO_MODULE_DIR)", ""

    system "make"
    # the spawn-multithreaded tests require more open files
    system "ulimit -n 1024; make check" if build.with? "test"
    system "make", "install"

    # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
    # have a pkgconfig file, so we add gettext lib and include paths here.
    gettext = Formula["gettext"].opt_prefix
    inreplace lib+"pkgconfig/glib-2.0.pc" do |s|
      s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext}/lib -lintl"
      s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
              "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext}/include"
    end

    (share+"gtk-doc").rmtree
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/gio/modules").mkpath
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <string.h>
      #include <glib.h>

      int main(void)
      {
          gchar *result_1, *result_2;
          char *str = "string";

          result_1 = g_convert(str, strlen(str), "ASCII", "UTF-8", NULL, NULL, NULL);
          result_2 = g_convert(result_1, strlen(result_1), "UTF-8", "ASCII", NULL, NULL, NULL);

          return (strcmp(str, result_2) == 0) ? 0 : 1;
      }
      EOS
    flags = ["-I#{include}/glib-2.0", "-I#{lib}/glib-2.0/include", "-lglib-2.0"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
