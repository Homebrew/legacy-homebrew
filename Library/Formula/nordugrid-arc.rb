class NordugridArc < Formula
  homepage "http://www.nordugrid.org"
  url "http://download.nordugrid.org/packages/nordugrid-arc/releases/5.0.0/src/nordugrid-arc_5.0.0.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nordugrid-arc/nordugrid-arc_5.0.0.orig.tar.gz"
  sha256 "59132ce88f0d88d9a08a56eb879fe9bd07b2eedfce1506508e71457b7f4add1b"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "libxml2"
  depends_on "globus-toolkit"

  fails_with :clang do
    build 500
    cause "Fails with 'template specialization requires \"template<>\"'"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-swig",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write("data")
    system "#{bin}/arccp", "foo", "bar"
  end
end
