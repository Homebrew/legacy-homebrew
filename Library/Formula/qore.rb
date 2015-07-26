class Qore < Formula
  desc "multi-threaded embedable scripting language"
  homepage "http://qore.org"
  url "https://downloads.sourceforge.net/project/qore/qore/0.8.11/qore-0.8.11.tar.bz2"
  sha256 "ce55fe2fa2bb85fd77cefe45d190d431fa5c6dcbd00cc4be499082130b755ae3"

  depends_on "flex"
  depends_on "bison"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-static",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qore", "--exec=print(1);"
  end
end
