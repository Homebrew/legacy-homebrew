class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "http://www.abisource.com/projects/link-grammar/"
  url "http://www.abisource.com/downloads/link-grammar/5.3.3/link-grammar-5.3.3.tar.gz"
  sha256 "832e1aa61d5eafbb7d3f4429847125067dcb6a3ece8c55ee8ffb1cd8c8db57d4"

  bottle do
    sha256 "5446839a520baa5d47b88ca0162e90bc7101365065eba46d01fbb3a77c138396" => :el_capitan
    sha256 "30808e4e9e65a8e5efaffa94b12b5bf1dfb14cf06af7421f9318a430d9f172d3" => :yosemite
    sha256 "3c4079d866c2ef2b02713575a371cbc555992c9a319269361da6d280750b91a8" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :ant => :build

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh", "--no-configure"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
