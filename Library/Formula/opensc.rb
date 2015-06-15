class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://downloads.sourceforge.net/project/opensc/OpenSC/opensc-0.15.0/opensc-0.15.0.tar.gz"
  sha256 "399b2107a69e3f67e4e76dc2dbd951dbced8e534b1e0f919e176aea9b85970d7"
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    sha1 "82b08c2bd2b58b7080797a441f8c641cbb101064" => :mavericks
    sha1 "b5107cad1a7b5c7808d8b93f497bfe64127fcbce" => :mountain_lion
    sha1 "26bc12047a4ca119fd37ff76ea4055226d88dc34" => :lion
  end

  stable do
    patch :p1 do
      url "https://github.com/carlhoerberg/OpenSC/commit/e5ae77cae32fdcc7a23d6bd0013c2fd115a43591.diff"
      sha256 "18bd9b6220bfc03768c6a7f5324e7f3981eff0bc8b8f7eb0f5159508b43d6863"
    end
  end

  option "with-man-pages", "Build manual pages"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook-xsl" if build.with? "man-pages"
  depends_on "openssl"

  def install
    args = []

    if build.with? "man-pages"
      args << "--with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sm",
                          "--enable-openssl",
                          "--enable-pcsc",
                          *args

    system "make", "install"
  end

  test do
    system "#{bin}/opensc-tool", "-i"
  end
end
