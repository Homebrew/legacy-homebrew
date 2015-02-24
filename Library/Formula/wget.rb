require "formula"

# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063

class Wget < Formula
  homepage "https://www.gnu.org/software/wget/"
  url "http://ftpmirror.gnu.org/wget/wget-1.16.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/wget/wget-1.16.1.tar.xz"
  sha1 "21cd7eee08ab5e5a14fccde22a7aec55b5fcd6fc"

  bottle do
    sha1 "0eef858e3208f2757f5105346bf79350f280a002" => :yosemite
    sha1 "9a02fd3da57a8afee248ebb09ea294c9d8729b3c" => :mavericks
    sha1 "0402cc64a2127d2b58ad8a9af3f161c1169a6dbd" => :mountain_lion
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
    if build.head?
      ln_s cached_download/".git", ".git"
      system "./bootstrap"
    end

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-iri" if build.without? "iri"
    args << "--disable-pcre" if build.without? "pcre"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/wget", "-O", "-", "www.google.com"
  end
end
