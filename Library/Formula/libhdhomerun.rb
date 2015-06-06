class Libhdhomerun < Formula
  desc "C library for controlling SiliconDust HDHomeRun TV tuners"
  homepage "https://www.silicondust.com/support/downloads/linux/"
  url "https://download.silicondust.com/hdhomerun/libhdhomerun_20150406.tgz"
  sha256 "fa6da8ab4461bca6cd852c41ba98bad3b58235477ed64cd96fb27aa3cea67d5a"

  bottle do
    cellar :any
    sha256 "236c6c1ca0509f2a6df08eb9fc5ab86648a17766ca74d42b658d53f5968f0c88" => :yosemite
    sha256 "18eca09a0756b459946d296ddf1a111f5377ed6b0008942bef6d0d848d261c30" => :mavericks
    sha256 "d4875e54fc917b0886ebc7b0960d3deac8d77c0b98f37434e7d5c1f5ee873153" => :mountain_lion
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
