class NordugridArc < Formula
  desc "Grid computing middleware"
  homepage "http://www.nordugrid.org"
  url "http://download.nordugrid.org/packages/nordugrid-arc/releases/5.0.0/src/nordugrid-arc_5.0.0.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nordugrid-arc/nordugrid-arc_5.0.0.orig.tar.gz"
  sha256 "59132ce88f0d88d9a08a56eb879fe9bd07b2eedfce1506508e71457b7f4add1b"
  revision 1

  bottle do
    sha256 "db44e56921dda90426b9bb78ac996bcc261e6e169584636bae3ed7acd31aa229" => :yosemite
    sha256 "bb1cd1b9729a5520e550a99c23d0d511e85daa5ead36f490940fff9e7ab073df" => :mavericks
    sha256 "2436284cbe98cb7fb0598ebed79a0ce4e82902316513d3e0bfce6fe749311174" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "libxml2"
  depends_on "globus-toolkit"

  needs :cxx11

  fails_with :clang do
    build 500
    cause "Fails with 'template specialization requires \"template<>\"'"
  end

  def install
    ENV.cxx11
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
