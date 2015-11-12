class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://downloads.sourceforge.net/project/opensc/OpenSC/opensc-0.15.0/opensc-0.15.0.tar.gz"
  sha256 "399b2107a69e3f67e4e76dc2dbd951dbced8e534b1e0f919e176aea9b85970d7"
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    sha256 "46276adb22e13910a2a9718dfe22ff498b5db4c9bebc2670f7a90d985aedabc3" => :yosemite
    sha256 "1d3b371fa3644bb199f6fa8bf9728188a877ad76eac92e89d565ec50c059022c" => :mavericks
    sha256 "55b76e1388a8c9941adebe1ec1f9c7b86e7f0f636d5cc0aff64c88e419942b57" => :mountain_lion
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
