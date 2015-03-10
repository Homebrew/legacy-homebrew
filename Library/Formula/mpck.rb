class Mpck < Formula
  homepage "http://checkmate.gissen.nl/"
  url "http://checkmate.gissen.nl/checkmate-0.19.tar.gz"
  sha256 "940f95d445bab629051930ef61c5614bdfbe9df6f450f1ffab86eaf885e79195"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mpck", test_fixtures("test.mp3")
  end
end
