class RofsFiltered < Formula
  homepage "https://github.com/gburca/rofs-filtered"
  url "https://github.com/gburca/rofs-filtered/archive/rel-1.4.tar.gz"
  sha1 "3650f55510f800aa22e64aedf1841c020ce44c08"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on :osxfuse

  def install
    system "./autogen.sh"

    # Patch submitted upstream at https://github.com/gburca/rofs-filtered/pull/4
    system "echo '#define llistxattr(path, list, size) (listxattr(path, list, size, XATTR_NOFOLLOW))' >> hack.h"
    system "echo '#define lgetxattr(path, name, value, size) (getxattr(path, name, value, size, 0, XATTR_NOFOLLOW))' >> hack.h"
    system "echo '#define lsetxattr(path, name, value, size, flags) (setxattr(path, name, value, size, 0, flags | XATTR_NOFOLLOW))' >> hack.h"

    system "echo '#include \"hack.h\"' | cat - rofs-filtered.c > tmp && mv tmp rofs-filtered.c"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "CFLAGS=-I/usr/local/include/osxfuse/fuse",
                          "LDFLAGS=-L/usr/local/lib"

    system "make", "install"
  end

  test do
    system "rofs-filtered"
  end
end
