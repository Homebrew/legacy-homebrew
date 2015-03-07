class Libhdhomerun < Formula
  homepage "https://www.silicondust.com/support/downloads/linux/"
  url "http://download.silicondust.com/hdhomerun/libhdhomerun_20141210.tgz"
  sha1 "4f6827e17f8f79401f272f62089352fe01eae740"

  bottle do
    cellar :any
    sha1 "2c58f3fd30b8ea2f03c5f0edc051c6b0cdc9ca14" => :yosemite
    sha1 "cc8190e5256ae8ba11041449e98b7c85ae2565a2" => :mavericks
    sha1 "7e96bccea269523447a15356e8cb65216365ca99" => :mountain_lion
  end

  def install
    system "make"
    bin.install "hdhomerun_config"
    lib.install "libhdhomerun.dylib"
    include.install Dir["hdhomerun*.h"]
  end

  test do
    # Devices may be found or not found, with differing return codes
    discover = pipe_output("#{bin}/hdhomerun_config discover")
    outputs = ["no devices found", "hdhomerun device", "found at"]
    assert outputs.any? { |x| discover.include? x }
  end
end
