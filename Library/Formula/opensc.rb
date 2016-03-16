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
    revision 2
    sha256 "b84361bf93572c5b156e5e722408ad88f94ecb76ff5703ad731300cc2bf4a59d" => :el_capitan
    sha256 "68c918cc0aa1660dd91ed127b3d0dcc07a0ce4001cbdb530904b4aec04c6d48b" => :yosemite
    sha256 "def6a8fa98e04884692da8e0c01043b861c4879becb7a773b1321c2374b019d7" => :mavericks
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
