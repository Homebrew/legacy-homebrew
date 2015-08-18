class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://downloads.sourceforge.net/project/ntop/nDPI/nDPI-1.7.tar.gz"
  sha256 "714b745103a072462130b0e14cf31b2eb5270f580b7c839da5cf5ea75150262d"

  bottle do
    cellar :any
    sha256 "e9464d314479ba3e7a91422e0bc606cfd5f6e72e94d6441cc4fa30e9c925da5c" => :yosemite
    sha256 "1d6b1d860669b42766baa276ed948c342e2fa4fd28663ba64a90fd0e200ba9c4" => :mavericks
    sha256 "b814918b4fb9588de7126061ce4ac3eb41a5c3eee27c7432b669f6dc6921bfde" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-c"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
