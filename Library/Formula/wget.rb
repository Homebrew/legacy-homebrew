require "formula"

# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063

class Wget < Formula
  homepage "https://www.gnu.org/software/wget/"
  url "http://ftpmirror.gnu.org/wget/wget-1.16.tar.xz"
  mirror "https://ftp.gnu.org/gnu/wget/wget-1.16.tar.xz"
  sha1 "08d991acc80726abe57043a278f9da469c454503"

  bottle do
    sha1 "97196dab9c0eb7afc7060afec98fc8cda54459c2" => :yosemite
    sha1 "98af6113f187abc5613b7aa2fbc24feeaa964e4f" => :mavericks
    sha1 "d84826b6dca644b2ccf3b157fd8a092994de43e2" => :mountain_lion
  end

  head do
    url "git://git.savannah.gnu.org/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-iri" => "with-iri"
  deprecated_option "enable-debug" => "with-debug"

  option "with-iri", "Enable iri support"
  option "with-debug", "Build with debug support"

  depends_on "openssl"
  depends_on "libidn" if build.with? "iri"

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

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/wget", "-O", "-", "www.google.com"
  end
end
