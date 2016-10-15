class Shards < Formula
  desc "Dependency manager for the Crystal language"
  homepage "https://github.com/ysbaddaden/shards"
  url "https://github.com/ysbaddaden/shards/archive/v0.4.0.tar.gz"
  sha256 "fff0f3c6562023fd279c80becf3683d2ac922ff097dda12f544f51f4b383ae5c"

  depends_on "manastech/crystal/crystal-lang"
  depends_on "libyaml"

  def install
    system "make"
    bin.install "bin/shards"
  end

  test do
    assert_equal "Shards 0.4.0 (2015-09-19)",
      shell_output("#{bin/"shards"} --version").chomp
  end
end
