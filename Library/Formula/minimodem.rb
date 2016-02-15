class Minimodem < Formula
  desc "General-purpose software audio FSK modem"
  homepage "http://www.whence.com/minimodem/"
  url "http://www.whence.com/minimodem/minimodem-0.22.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/minimodem/minimodem_0.22.1.orig.tar.gz"
  sha256 "f41dd27367ffe1607c6b631bb7ab6e1c5c099490e295ce1b603cc54416845ce9"
  revision 1

  bottle do
    cellar :any
    sha256 "729d3fe2eb6aa74ef0a8133317239873bd3e15a668f6386a32d4ce53ef3db9b7" => :el_capitan
    sha256 "2f32446051c0d053bbd2282f032d4b601b825910a70966cb16aace8c113a3c76" => :yosemite
    sha256 "23478632c422c9445cb147624ac8048d39186e1955d4005dbde887bbd0113ed8" => :mavericks
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
