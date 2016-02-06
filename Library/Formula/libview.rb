class Libview < Formula
  desc "VMware's incredibly exciting widgets"
  homepage "http://view.sourceforge.net/"
  url "http://httpredir.debian.org/debian/pool/main/libv/libview/libview_0.6.6.orig.tar.gz"
  sha256 "394583d2d28c334684d512eb2a260db51a877b84319f74a2425b79b5780f3ad8"
  head "svn://svn.code.sf.net/p/view/code/trunk/libview"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk+"
  depends_on "gtkmm"
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :x11

  needs :cxx11

  # upstream bug: http://sourceforge.net/p/view/bugs/1/
  patch do
    url "http://sourceforge.net/p/view/bugs/_discuss/thread/7b22d179/1941/attachment/libview-0.5.6.diff"
    sha256 "4d93c8067fb1d371780a665fff731dd27ce3daac983ea63efbb7ba2bad492d39"
  end

  def install
    # Homebrew renames libtool to glibtool intentionally.
    inreplace "autogen.sh", "libtool", "glibtool"
    # Install some test utilities.
    inreplace "tests/Makefile.am", "noinst_PROGRAMS", "libexec_PROGRAMS"

    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    # Dist aclocal.m4 is not compatible with homebrew's libtool. Re-generate.
    system "./autogen.sh", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--libs", "--cflags", "libview"
  end
end
