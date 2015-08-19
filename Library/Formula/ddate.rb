class Ddate < Formula
  desc "Converts boring normal dates to fun Discordian Date"
  homepage "https://github.com/bo0ts/ddate"
  url "https://github.com/bo0ts/ddate/archive/v0.2.2.tar.gz"
  sha256 "d53c3f0af845045f39d6d633d295fd4efbe2a792fd0d04d25d44725d11c678ad"

  bottle do
    cellar :any
    sha1 "af6bacba82ac71f204e915ae669b98cd202e79ad" => :mavericks
    sha1 "8df50f3601d86819e0b491f7508f6267c3252aa0" => :mountain_lion
    sha1 "7c4699766bea102425380bde8914c95e53fa99ff" => :lion
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
