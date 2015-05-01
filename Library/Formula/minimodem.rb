class Minimodem < Formula
  homepage "http://www.whence.com/minimodem/"
  url "http://www.whence.com/minimodem/minimodem-0.21.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/m/minimodem/minimodem_0.21.orig.tar.gz"
  sha256 "a3ae6861b65360d520e1ce047d7d4d6cf1a833a2ff42d627a1846cf24b3931cf"

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
