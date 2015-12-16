class Schroedinger < Formula
  desc "High-speed implementation of the Dirac codec"
  homepage "http://diracvideo.org/"
  url "http://diracvideo.org/download/schroedinger/schroedinger-1.0.11.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/schroedinger/schroedinger_1.0.11.orig.tar.gz"
  sha256 "1e572a0735b92aca5746c4528f9bebd35aa0ccf8619b22fa2756137a8cc9f912"

  bottle do
    cellar :any
    sha256 "1b2986f82784266c17734725e126c50bf3075c47530bf7befc16778629bf3dda" => :el_capitan
    sha256 "29ddcf886a3b6d9b58a8d2be97e7f57e3145a242554f859fea2a36ffa0f00e4f" => :yosemite
    sha256 "4ca73a79fcd8c0e0c0ae8bb40e61a403cfb3fec98bbd69269d4f2d9d81b90d52" => :mavericks
    sha256 "9e927edad70b69b05222e3bc0d223570a346618e3750b2d99e8fbc2fb6fc40bc" => :mountain_lion
  end

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
