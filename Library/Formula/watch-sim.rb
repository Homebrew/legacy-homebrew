class WatchSim < Formula
  homepage "https://github.com/alloy/watch-sim"
  url "https://github.com/alloy/watch-sim/archive/1.0.0.tar.gz"
  sha256 "138616472e980276999fee47072a24501ea53ce3f7095a3de940e683341b7cba"
  head "https://github.com/alloy/watch-sim.git"

  depends_on :xcode => "6.2"

  def install
    system "make"
    bin.install "watch-sim"
  end

  test do
    assert_match(/Usage: watch-sim/,
                 shell_output("#{bin}/watch-sim 2>&1", 1))
  end
end
