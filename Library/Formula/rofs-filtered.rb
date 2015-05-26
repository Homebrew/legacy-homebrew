class RofsFiltered < Formula
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/rel-1.5.tar.gz"
  sha256 "4c97a85e7993945e417c45cc80fcb8ad780f310142b8f94e8b3bed005733a698"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on :osxfuse
  depends_on :macos => :yosemite

  def install
    ENV.prepend "CPPFLAGS", "-I#{HOMEBREW_PREFIX}/include/osxfuse/fuse"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-libfuse=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    system "rofs-filtered"
  end
end
