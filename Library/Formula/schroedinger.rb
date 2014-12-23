class Schroedinger < Formula
  homepage "http://diracvideo.org/"
  url "http://diracvideo.org/download/schroedinger/schroedinger-1.0.11.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/schroedinger/schroedinger_1.0.11.orig.tar.gz"
  sha1 "c01ee0bed6c1bd7608763927f719f94ebc6aaa41"

  head do
    url "git://diracvideo.org/git/schroedinger.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "orc"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # The test suite is known not to build against Orc >0.4.16 in Schroedinger 1.0.11.
    # A fix is in upstream, so test when pulling 1.0.12 if this is still needed. See:
    # http://www.mail-archive.com/schrodinger-devel@lists.sourceforge.net/msg00415.html
    inreplace "Makefile" do |s|
      s.change_make_var! "SUBDIRS", "schroedinger doc tools"
      s.change_make_var! "DIST_SUBDIRS", "schroedinger doc tools"
    end

    system "make", "install"
  end
end
