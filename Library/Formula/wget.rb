# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063

class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "http://ftpmirror.gnu.org/wget/wget-1.17.tar.xz"
  mirror "https://ftp.gnu.org/gnu/wget/wget-1.17.tar.xz"
  sha256 "bd69d63acbf329a8286ccebbe63cd4fecc998718131a0d4b2ab9239542d2bb87"

  bottle do
    sha256 "7a0981c0be8037f97ed2f74c7ae8c2404629d1b50abfca792aaa857cbc68d05f" => :el_capitan
    sha256 "29aa8f54fe9ebf09ee671bbca3ac0c62cd8e63919bcab7d38167a6332a4939a4" => :yosemite
    sha256 "3c15fe7e35dcba11c897df8daa5ebcc3c9a60a6673b8ca6477f3b204104a85d2" => :mavericks
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

  depends_on "openssl" => :recommended
  depends_on "libressl" => :optional
  depends_on "libidn" if build.with? "iri"
  depends_on "pcre" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
    ]

    if build.with? "libressl"
      args << "--with-libssl-prefix=#{Formula["libressl"].opt_prefix}"
    else
      args << "--with-libssl-prefix=#{Formula["openssl"].opt_prefix}"
    end

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-iri" if build.without? "iri"
    args << "--disable-pcre" if build.without? "pcre"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "-", "https://google.com"
  end
end
