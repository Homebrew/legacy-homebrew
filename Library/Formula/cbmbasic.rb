class Cbmbasic < Formula
  desc "Commodore BASIC V2 as a scripting language"
  homepage "https://github.com/mist64/cbmbasic"
  url "https://downloads.sourceforge.net/project/cbmbasic/cbmbasic/1.0/cbmbasic-1.0.tgz"
  sha256 "2735dedf3f9ad93fa947ad0fb7f54acd8e84ea61794d786776029c66faf64b04"
  head "https://github.com/mist64/cbmbasic.git"

  bottle do
    cellar :any
    sha256 "d7285a8376e20ac008e51814a97f155f8ac80ce94a809c953ee63932a1d2c1d7" => :yosemite
    sha256 "ffe1126f8e12f15471abadf280fa83b8e77770170749805a28fdaa1a1adf51b0" => :mavericks
    sha256 "04ac2ecc60ab69d7d4c6150260aeb8c63dc0bb3974d554241b8470792332be56" => :mountain_lion
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}"
    bin.install "cbmbasic"
  end

  test do
    assert_match(/READY.\r\n 1/, pipe_output("#{bin}/cbmbasic", "PRINT 1\n", 0))
  end
end
