require 'formula'

# NOTE: Configure will fail if using awk 20110810 from dupes.
# Upstream issue: https://savannah.gnu.org/bugs/index.php?37063

class Wget < Formula
  homepage 'http://www.gnu.org/software/wget/'
  url 'http://ftpmirror.gnu.org/wget/wget-1.15.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz'
  sha1 'f3c925f19dfe5ed386daae4f339175c108c50574'

  bottle do
    sha1 "f3dc7cadc6099443213ada31019c603818c46717" => :mavericks
    sha1 "21f0463fd39bcf363814929d863850608c7b87c1" => :mountain_lion
    sha1 "934a195951c6df94bebc3e710dd15398bb6cd7b9" => :lion
  end

  head do
    url 'git://git.savannah.gnu.org/wget.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  option "enable-iri", "Enable iri support"
  option "enable-debug", "Build with debug support"

  depends_on "openssl"
  depends_on "libidn" if build.include? "enable-iri"

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula.factory("openssl").opt_prefix}
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
