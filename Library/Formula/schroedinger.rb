class Schroedinger < Formula
  desc "High-speed implementation of the Dirac codec"
  homepage "http://diracvideo.org/"
  url "http://diracvideo.org/download/schroedinger/schroedinger-1.0.11.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/schroedinger/schroedinger_1.0.11.orig.tar.gz"
  sha256 "1e572a0735b92aca5746c4528f9bebd35aa0ccf8619b22fa2756137a8cc9f912"

  bottle do
    cellar :any
    sha1 "a1e426a2099a31cbacdea032bef1b21fbc48ebe8" => :yosemite
    sha1 "ba01918d1a3b8874530b6ecc0fb04bdf67249724" => :mavericks
    sha1 "25945536569871536fe60e0fc97bdfc49d83e309" => :mountain_lion
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
