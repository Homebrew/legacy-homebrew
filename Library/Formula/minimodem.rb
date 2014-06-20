require "formula"

class Minimodem < Formula
  homepage "http://www.whence.com/minimodem/"
  url "http://www.whence.com/minimodem/minimodem-0.19.tar.gz"
  sha1 "4548677df8c1e16cb4c31d26502017f3204ad128"

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
    system "#{bin}/minimodem", "--version"
  end
end
