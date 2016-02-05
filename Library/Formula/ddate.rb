class Ddate < Formula
  desc "Converts boring normal dates to fun Discordian Date"
  homepage "https://github.com/bo0ts/ddate"
  url "https://github.com/bo0ts/ddate/archive/v0.2.2.tar.gz"
  sha256 "d53c3f0af845045f39d6d633d295fd4efbe2a792fd0d04d25d44725d11c678ad"

  bottle do
    cellar :any
    sha256 "8b7017ecb63545d996e06008df12e7cbd3b9da90545d2accb5ebf28c6af4f088" => :mavericks
    sha256 "91f1bb80f8fdf4fd994fba1cddafc94a17b2daa0f8a5483735a8dc38c9eda5f1" => :mountain_lion
    sha256 "12b52e2c5881c51aa902c10b236dc6c2e42e9d4b7e666f19b86a86bf211e398a" => :lion
  end

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install "ddate"
    man1.install "ddate.1"
  end

  test do
    output = shell_output("#{bin}/ddate 20 6 2014").strip
    assert_equal "Sweetmorn, Confusion 25, 3180 YOLD", output
  end
end
