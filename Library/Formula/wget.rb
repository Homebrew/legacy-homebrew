# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063

class Wget < Formula
  homepage "https://www.gnu.org/software/wget/"
  url "http://ftpmirror.gnu.org/wget/wget-1.16.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/wget/wget-1.16.2.tar.xz"
  sha1 "a77b455ad01620ea3b709db2e07e6841da518f38"

  bottle do
    sha1 "4a25ec9c585fd7d9b661ae3ee865a990e933b34c" => :yosemite
    sha1 "5548c03ce42dadf5bd59638ce9506817e78edd96" => :mavericks
    sha1 "8d088a434ac541b630da448efc6a64bcaef84ffb" => :mountain_lion
  end

  head do
    url "git://git.savannah.gnu.org/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-iri" => "with-iri"
  deprecated_option "enable-debug" => "with-debug"

  option "with-iri", "Enable iri support"
  option "with-debug", "Build with debug support"

  depends_on "openssl"
  depends_on "libidn" if build.with? "iri"
  depends_on "pcre" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-iri" if build.without? "iri"
    args << "--disable-pcre" if build.without? "pcre"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/wget", "-O", "-", "www.google.com"
  end
end
