class Jpeginfo < Formula
  desc "Prints information and tests integrity of JPEG/JFIF files"
  homepage "https://www.kokkonen.net/tjko/projects.html"
  url "https://www.kokkonen.net/tjko/src/jpeginfo-1.6.1.tar.gz"
  sha256 "629e31cf1da0fa1efe4a7cc54c67123a68f5024f3d8e864a30457aeaed1d7653"

  bottle do
    cellar :any
    sha256 "53f66b7928d79395f1b47402793a597941c1936cae8f86659f15f4fd5b4a9952" => :el_capitan
    sha256 "6ca8a76e285edd1d698d4c6528977cc85639d72d629818929b52483cd7558a25" => :yosemite
    sha256 "07f34a0a91c08be54681538335f9688eaa9d7e3298c94c4960a86526028191a2" => :mavericks
  end

  depends_on "jpeg"

  def install
    ENV.deparallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/jpeginfo", "--help"
  end
end
