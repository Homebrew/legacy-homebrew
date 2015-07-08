class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.3.18.tar.gz"
  sha256 "fe9c0c78c8fca1ef9b61474f2039dc3634f2caf1c547b7ddc7a4eaa31238b2c9"

  # these dependencies are only needed for the patch
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fixes ./configure error on OS X
  # https://github.com/rpodgorny/uptimed/issues/4
  patch :DATA

  def install
    # this is needed for the patch
    system "autoreconf", "-fvi"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Per MacPorts
    inreplace "Makefile", "/var/spool/uptimed", "#{var}/uptimed"
    inreplace "libuptimed/urec.h", "/var/spool", var
    inreplace "etc/uptimed.conf-dist", "/var/run", "#{var}/uptimed"
    system "make", "install"
  end

  test do
    system "#{bin}/uprecords"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 9f0b9a2..e9e29b6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,7 +17,6 @@ case "$host" in
             AC_SUBST([systemdsystemunitdir], [$with_systemdsystemunitdir])
             AC_OUTPUT([etc/uptimed.service])
         fi
-        AM_CONDITIONAL(HAVE_SYSTEMD, [test -n "$with_systemdsystemunitdir" -a "x$with_systemdsystemunitdir" != xno ])
     ;;
   *-hpux*)
     AC_DEFINE(PLATFORM_HPUX, 1, [Define if you are compiling for HP/UX])
@@ -54,6 +53,8 @@ case "$host" in
     ;;
 esac

+AM_CONDITIONAL(HAVE_SYSTEMD, [test -n "$with_systemdsystemunitdir" -a "x$with_systemdsystemunitdir" != xno ])
+
 AC_REPLACE_FUNCS(getopt)
 AC_CHECK_HEADERS(getopt.h)
 AC_CHECK_FUNCS([getdtablesize])
