class Qore < Formula
  desc "Multi-threaded embeddable scripting language"
  homepage ""
  url "https://github.com/qorelanguage/qore/releases/download/release-0.8.11.1/qore-0.8.11.1.tar.bz2"
  version "0.8.11.1"
  sha256 "bd9b8463024c204a06c4c32336d63ad573a27fce331f0345eb95c12f7c7a77fe"
  head "https://github.com/qorelanguage/qore.git"

  depends_on "flex" => :build if MacOS.version < :yosemite
  depends_on "openssl"
  depends_on "pcre"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "automake" if build.head?
  depends_on "libtool" if build.head?

  def install
    if build.head?
      system "./reconf.sh"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qore", "-X '1'"
  end
end
