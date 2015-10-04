class Minimodem < Formula
  desc "General-purpose software audio FSK modem"
  homepage "http://www.whence.com/minimodem/"
  url "http://www.whence.com/minimodem/minimodem-0.22.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/m/minimodem/minimodem_0.22.1.orig.tar.gz"
  sha256 "f41dd27367ffe1607c6b631bb7ab6e1c5c099490e295ce1b603cc54416845ce9"

  bottle do
    cellar :any
    sha256 "44a3af4831b9737bfdb8e70ac1bd32828c109b0d30a098cbb0fa6632e4e4d0bb" => :yosemite
    sha256 "6102f448bead7d286f3def6b62db40cced52ce34a49414100db0edb1ead2a7dc" => :mavericks
    sha256 "1b87248c4cf2ed36d245531e5e9799ada3ea05aa448258d2023790c65503ba58" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile"
  depends_on "fftw"
  depends_on "pulseaudio"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-alsa"
    system "make", "install"
  end

  test do
    system "#{bin}/minimodem", "--benchmarks"
  end
end
