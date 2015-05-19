class WatchSim < Formula
  desc "Command-line WatchKit application launcher"
  homepage "https://github.com/alloy/watch-sim"
  url "https://github.com/alloy/watch-sim/archive/1.0.0.tar.gz"
  sha256 "138616472e980276999fee47072a24501ea53ce3f7095a3de940e683341b7cba"
  head "https://github.com/alloy/watch-sim.git"

  bottle do
    cellar :any
    sha256 "06d95de04920d991ee1ee5a9e8035fb12ef103aa072382cef82cab683797e8d9" => :yosemite
    sha256 "b04846befdb378679cdd93bdf182784a8ed0da3957cb0b4a124576b3cd06e54c" => :mavericks
  end

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
