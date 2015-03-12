class Oggz < Formula
  homepage "https://www.xiph.org/oggz/"
  url "http://downloads.xiph.org/releases/liboggz/liboggz-1.1.1.tar.gz"
  sha256 "6bafadb1e0a9ae4ac83304f38621a5621b8e8e32927889e65a98706d213d415a"

  depends_on "pkg-config" => :build
  depends_on "libogg"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/oggz", "known-codecs"
  end
end
