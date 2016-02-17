class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/downloads/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20150826.tgz"
  sha256 "907dfbd1eb82aebd8b09e7c00c21a02433e6baaacf4a4f99aa2511b1d5244baf"

  bottle do
    cellar :any
    sha256 "ea69634a90aadfb41bf9a31df6b869352c83384182284296ce3804a550d5f2fd" => :el_capitan
    sha256 "609b431d32db9dcbfa7688ed3a48531410850118086c7f87d835fb86e58da7af" => :yosemite
    sha256 "995a804a8965aa82c614ea7f3dcb7db009a88c860fae241302b15ff8afd72284" => :mavericks
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
