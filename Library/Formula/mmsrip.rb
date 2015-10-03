class Mmsrip < Formula
  desc "Client for the MMS:// protocol"
  homepage "http://nbenoit.tuxfamily.org/index.php?page=MMSRIP"
  url "http://nbenoit.tuxfamily.org/projects/mmsrip/mmsrip-0.7.0.tar.gz"
  sha256 "5aed3cf17bfe50e2628561b46e12aec3644cfbbb242d738078e8b8fce6c23ed6"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mmsrip", "-v"
  end
end
