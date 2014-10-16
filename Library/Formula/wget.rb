require 'formula'

# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063

class Wget < Formula
  homepage 'http://www.gnu.org/software/wget/'
  url 'http://ftpmirror.gnu.org/wget/wget-1.15.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz'
  sha1 'f3c925f19dfe5ed386daae4f339175c108c50574'
  revision 2

  bottle do
    revision 1
    sha1 "5e3dd7a6e79e4de274b1c1dc1baa6d8110a56000" => :mavericks
    sha1 "f4e4664b78cfc1c515e791f3b2ffedf7207a2a22" => :mountain_lion
    sha1 "217a42b233f21fcb693723f91ec6df0ae168609e" => :lion
  end

  head do
    url 'git://git.savannah.gnu.org/wget.git'

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
  depends_on "libidn" if build.include? "enable-iri"

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-debug" unless build.include? "enable-debug"
    args << "--disable-iri" unless build.include? "enable-iri"

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/wget", "-O", "-", "www.google.com"
  end
end
