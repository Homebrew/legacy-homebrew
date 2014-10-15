require "formula"

class Libhdhomerun < Formula
  homepage "https://www.silicondust.com/support/downloads/linux/"
  url "http://download.silicondust.com/hdhomerun/libhdhomerun_20141210.tgz"
  sha1 "4f6827e17f8f79401f272f62089352fe01eae740"

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
