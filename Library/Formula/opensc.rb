class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  head "https://github.com/OpenSC/OpenSC.git"

  stable do
    url "https://github.com/OpenSC/OpenSC/archive/0.15.0.tar.gz"
    sha256 "8f8f8cf52e0252334e4dfdccca829b876a3de6340deb772aa0bfe0c0cc10eaf5"

    patch :p1 do
      url "https://github.com/carlhoerberg/OpenSC/commit/e5ae77cae32fdcc7a23d6bd0013c2fd115a43591.diff"
      sha256 "18bd9b6220bfc03768c6a7f5324e7f3981eff0bc8b8f7eb0f5159508b43d6863"
    end
  end

  bottle do
    revision 1
    sha256 "3c68218181dc025c0a2784ef1fa15834cdd890493b7603da86b6f1a4d2f90e5c" => :el_capitan
    sha256 "12298b0c9b6cf85d37f861962f2dd719ad51b5f4485338acf17985e2e18d334a" => :yosemite
    sha256 "08501fbffbb7f534ac5319104f7eb05243209897c6b958b10fc62024cf4a0f50" => :mavericks
  end

  devel do
    url "https://github.com/OpenSC/OpenSC/archive/v0.16.0-pre1.tar.gz"
    sha256 "097132ce24d8c19f9ef79b46fde558698ed1dc1bd616d8ad275e32eaf79e5ba6"
    version "0.16.0-pre1"
  end

  option "without-man-pages", "Skip building manual pages"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook-xsl" => :build if build.with? "man-pages"
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-sm
      --enable-openssl
      --enable-pcsc
    ]

    if build.with? "man-pages"
      args << "--with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "0.15.0", shell_output("opensc-tool -i")
  end
end
