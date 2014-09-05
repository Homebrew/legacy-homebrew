class Wsmancli < Formula
  homepage "https://github.com/Openwsman/wsmancli"
  url "https://github.com/Openwsman/wsmancli/archive/v2.3.1.tar.gz"
  sha1 "a9b3dbe14d257687da4ace7c142e829c05c80994"

  depends_on "openwsman"
  depends_on "autoconf"   => :build
  depends_on "automake"   => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wsman", "-q"
  end
end
